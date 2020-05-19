output "ecs_cluster_id" {
  value = aws_ecs_cluster.project_1.id
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.project_1.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.project_1.name
}

output "ecs_service_name" {
  value = aws_ecs_service.ecs.name
}

output "policy_cpu_low" {
  value = aws_appautoscaling_policy.cpu_low.arn
}

output "policy_cpu_high" {
  value = aws_appautoscaling_policy.cpu_high.arn
}