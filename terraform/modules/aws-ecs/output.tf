output "ecs_cluster_id" {
  value = aws_ecs_cluster.project_1.id
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.project_1.arn
}
