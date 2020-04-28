# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html

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
  retention_in_days = 30
}

data "aws_region" "current" {
}

# AWS Task Definition
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
        image     = "${var.repository_url}:latest"
        essential = true
        cpu       = 256
        memory    = 512
        mountPoints = [
          {
            sourceVolume = var.volume_name
            containerPath = "/var/www/html"
            readOnly = false
          }
        ],
        secrets = [
          { 
            name = "WORDPRESS_DB_HOST"
            valueFrom = "PROJ1_DB_HOST"
          },
          { 
            name = "WORDPRESS_DB_USER"
            valueFrom = "PROJ1_DB_USER"
          }, 
          { 
            name = "WORDPRESS_DB_PASSWORD"
            valueFrom = "PROJ1_DB_PASSWORD"
          }, 
          { 
            name = "WORDPRESS_DB_NAME"
            valueFrom = "PROJ1_DB_NAME"
          }             
        ]
        portMappings = [
          {
            containerPort = 80
            hostPort      = 80
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
