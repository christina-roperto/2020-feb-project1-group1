variable "project_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
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

variable "target_group_arn" {
  type = string
}

variable "ecs_service_depends_on" {
  type = any
}

variable "launch_type" {
  type    = string
  default = "FARGATE"
}

variable "platform_version" {
  type    = string
  default = "1.4.0"
}

variable "desired_count" {
  type    = number
  default = 2
}

variable "assign_public_ip" {
  type    = bool
  default = true
}

variable "project_env" {
  type = string
}

## Required arguments
variable "family" {
  type        = string
  description = "A unique name for your task definition."
}

variable "file_system_id" {
  type = string
}

variable "file_system_dns_name" {
  type        = string
  description = "The DNS name for the given subnet/AZ per documented convention https://docs.aws.amazon.com/efs/latest/ug/mounting-fs-mount-cmd-dns-name.html."
}

## Optional arguments
variable "requires_compatibilities" {
  type    = list(string)
  default = ["FARGATE"]
}

variable "cpu" {
  type        = number
  description = "(Optional) The number of cpu units used by the task. If the requires_compatibilities is FARGATE this field is required."
  default     = 256
}

variable "memory" {
  type        = number
  description = "(Optional) The amount (in MiB) of memory used by the task. If the requires_compatibilities is FARGATE this field is required."
  default     = 512
}

variable "network_mode" {
  type        = string
  description = "(Optional) The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host."
  default     = "awsvpc"
}

variable "tags" {
  type = map

  default = {
    Environment = "Project1 - Dev"
  }
}

variable "volume_name" {
  type    = string
  default = "wordpress-storage"
}

variable "volume_scope" {
  type    = string
  default = "shared"
}

variable "volume_autoprovision" {
  type    = bool
  default = true
}

variable "volume_driver" {
  type    = string
  default = "local"
}

variable "file_system_type" {
  type    = string
  default = "nfs"
}

variable "repository_url" {
  type = string
}

variable "repository_version" {
  type        = string
  description = "version of Docker image to be used"
}

variable "retention_in_days" {
  type    = number
  default = 30
}

variable "containerPort" {
  type    = number
  default = 80
}

variable "hostPort" {
  type    = number
  default = 80
}
