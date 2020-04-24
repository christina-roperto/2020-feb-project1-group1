# AWS Task Definition
resource "aws_ecs_task_definition" "project_1" {
  family                   = var.family
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = var.network_mode
  tags                     = var.tags

  container_definitions = jsonencode(
    [
      {
        name      = "project_1"
        image     = "wordpress:latest"
        essential = true
        cpu       = 256
        memory    = 512
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

    docker_volume_configuration {
      scope         = var.volume_scope
      autoprovision = var.volume_autoprovision
      driver        = var.volume_driver

      driver_opts = {
        "type"   = var.file_system_type
        "device" = "${var.file_system_dns_name}:/"
        "o"      = "addr=${var.file_system_dns_name},rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport"
      }
    }
  }
}
