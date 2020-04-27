output "repository_url" {
  value = module.aws-ecr.repository_url
}

output "alb_dns" {
  value = module.aws-alb.alb_main_hostname
}