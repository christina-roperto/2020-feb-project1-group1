data "aws_iam_role" "ecs_role" {
  name = "ecsTaskExecutionRole"
}

# AWS Task Definition
resource "aws_ecs_task_definition" "project_1" {
  family                   = var.family
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = var.network_mode
  tags                     = var.tags
  execution_role_arn       = data.aws_iam_role.ecs_role.arn

  container_definitions = jsonencode(
    [
      {
        name      = "project_1"
        image     = "${var.repository_url}:latest"
        essential = true
        cpu       = 256
        memory    = 512
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
      }
    ]
  )

  volume {
    name = var.volume_name

    efs_volume_configuration {
      file_system_id = var.file_system_id
      root_directory = "/opt/data"
    }

    # docker_volume_configuration {
    #   scope         = var.volume_scope
    #   autoprovision = var.volume_autoprovision
    #   driver        = var.volume_driver

    #   driver_opts = {
    #     "type"   = var.file_system_type
    #     "device" = "${var.file_system_dns_name}:/"
    #     "o"      = "addr=${var.file_system_dns_name},rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport"
    #   }
    # }
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
  role       = data.aws_iam_role.ecs_role.name
  policy_arn = aws_iam_policy.get_ssm.arn
}