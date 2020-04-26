output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}

output "alb_main_id" {
  value = aws_alb.main.id
}

output "alb_main_hostname" {
  value = aws_alb.main.dns_name
}
