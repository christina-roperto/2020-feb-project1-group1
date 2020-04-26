variable "project_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "cluster_id" {
  type = string
}

variable "ecs_task_definition_arn" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "container_name" {
  type = string
}

variable "container_port" {
  type = string
}

variable "alb_id" {
  type = string
}

variable "security_group_id" {
  type = string
}