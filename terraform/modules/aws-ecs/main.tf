data "aws_region" "current" {
}

resource "aws_ecs_service" "ecs" {
  name             = var.project_name
  cluster          = aws_ecs_cluster.project_1.id
  task_definition  = aws_ecs_task_definition.project_1.arn
  launch_type      = var.launch_type
  platform_version = var.platform_version
  desired_count    = var.desired_count

  network_configuration {
    assign_public_ip = var.assign_public_ip
    subnets          = var.subnet_ids
    security_groups  = [var.security_group_id]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  depends_on = [var.ecs_service_depends_on]
}

resource "aws_ecs_cluster" "project_1" {
  name = var.project_name

  tags = {
    Environment = var.project_env
  }
}

resource "aws_iam_role" "ecs_role" {
  name = "${var.project_name}-ecsTaskExecutionRole"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = "sts:AssumeRole"
          Principal = {
            Service = "ecs-tasks.amazonaws.com"
          }
        },
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "ecs_role" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "log" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = var.retention_in_days
}

resource "aws_ecs_task_definition" "project_1" {
  family                   = var.family
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = var.network_mode
  tags                     = var.tags
  execution_role_arn       = aws_iam_role.ecs_role.arn

  container_definitions = jsonencode(
    [
      {
        name      = "project_1"
        image     = "${var.repository_url}:${var.repository_version}"
        essential = true
        cpu       = var.cpu
        memory    = var.memory
        mountPoints = [
          {
            sourceVolume  = var.volume_name
            containerPath = "/var/www/html"
            readOnly      = false
          }
        ],
        secrets = [
          {
            name      = "WORDPRESS_DB_HOST"
            valueFrom = "PROJ1_DB_HOST"
          },
          {
            name      = "WORDPRESS_DB_USER"
            valueFrom = "PROJ1_DB_USER"
          },
          {
            name      = "WORDPRESS_DB_PASSWORD"
            valueFrom = "PROJ1_DB_PASSWORD"
          },
          {
            name      = "WORDPRESS_DB_NAME"
            valueFrom = "PROJ1_DB_NAME"
          }
        ]
        portMappings = [
          {
            containerPort = var.containerPort
            hostPort      = var.hostPort
          }
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = aws_cloudwatch_log_group.log.name
            awslogs-region        = data.aws_region.current.name
            awslogs-stream-prefix = "ecs"
          }
        }
      }
    ]
  )

  volume {
    name = var.volume_name

    efs_volume_configuration {
      file_system_id = var.file_system_id
      root_directory = "/"
    }
  }
}

resource "aws_iam_policy" "get_ssm" {
  name        = "ECS-Secrets"
  path        = "/"
  description = "Get parameters SSM"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ssm:GetParameters",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm-attach" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = aws_iam_policy.get_ssm.arn
}

resource "aws_appautoscaling_target" "main" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.project_1.name}/${aws_ecs_service.ecs.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "cpu_high" {
  name               = "${var.project_name}-ecs_service-scale_out-cpu_utilization"
  resource_id        = "service/${aws_ecs_cluster.project_1.name}/${aws_ecs_service.ecs.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.autoscale_cooldown
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = var.scale_out_step_adjustment["metric_interval_lower_bound"]
      scaling_adjustment          = var.scale_out_step_adjustment["scaling_adjustment"]
    }
  }

  depends_on = [aws_appautoscaling_target.main]
}

resource "aws_appautoscaling_policy" "cpu_low" {
  name               = "${var.project_name}-ecs_service-scale_in-cpu_utilization"
  resource_id        = "service/${aws_ecs_cluster.project_1.name}/${aws_ecs_service.ecs.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.autoscale_cooldown
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = var.scale_in_step_adjustment["metric_interval_upper_bound"]
      scaling_adjustment          = var.scale_in_step_adjustment["scaling_adjustment"]
    }
  }

  depends_on = [aws_appautoscaling_target.main]
}