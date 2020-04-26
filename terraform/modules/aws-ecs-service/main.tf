resource "aws_ecs_service" "ecs" {
  name            = var.project_name
  cluster         = var.cluster_id
  task_definition = var.ecs_task_definition_arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    assign_public_ip = "true"
    subnets          = var.subnet_ids
    security_groups  = [var.security_group_id]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
}
