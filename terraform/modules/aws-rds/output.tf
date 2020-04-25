// aws_rds_cluster
output "default_rds_cluster_arn" {
  description = "The ID of the cluster"
  value       = aws_rds_cluster.default.arn
}

output "default_rds_cluster_id" {
  description = "The ID of the cluster"
  value       = aws_rds_cluster.default.id
}

output "default_rds_cluster_resource_id" {
  description = "The Resource ID of the cluster"
  value       = aws_rds_cluster.default.cluster_resource_id
}

output "default_rds_cluster_endpoint" {
  description = "The cluster endpoint"
  value       = aws_rds_cluster.default.endpoint
}

output "default_rds_cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = aws_rds_cluster.default.reader_endpoint
}

output "cluster_identifier" {
  value = aws_rds_cluster.default.cluster_identifier
}