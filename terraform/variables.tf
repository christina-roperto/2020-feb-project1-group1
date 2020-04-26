
variable "project_name" {
  default = "devops-project-01"
}

variable "project_env" {
  default = "wordpress-dev"
}

variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "10.10.0.0/16"
}

variable "alert_sms" {
  type        = string
  description = "Mobile number that will receive cloudwatch alerts, example: +614xxxxxxxx"
  default     = ""
}
