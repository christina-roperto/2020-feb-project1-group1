## Required arguments
variable "family" {
  type        = string
  description = "A unique name for your task definition."
}

variable "file_system_id" {
  type        = string
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
  type        = string
  description = "(Optional) The number of cpu units used by the task. If the requires_compatibilities is FARGATE this field is required."
  default     = 256
}

variable "memory" {
  type        = string
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

variable "project_name" {
  type = string
}

variable "repository_url" {
  type = string
}