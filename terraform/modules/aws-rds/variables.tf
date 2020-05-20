## Required arguments

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "env_prefix" {
  type = string
}

## Optional arguments
variable "name_prefix" {
  type    = string
  default = "wordpress"
}

variable "resource_name_prefix" {
  type    = string
  default = "aurora"
}

variable "identifier" {
  type    = string
  default = "mysql"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "backup_retention_period" {
  type    = number
  default = 1
}

variable "backup_window" {
  type    = string
  default = "03:01-06:00"
}

variable "maintenance_window" {
  type    = string
  default = "Mon:00:00-Mon:03:00"
}

variable "engine" {
  type    = string
  default = "aurora"
}

variable "engine_mode" {
  type    = string
  default = "serverless"
}

variable "engine_version" {
  type    = string
  default = "5.6.10a"
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "database_name" {
  type    = string
  default = "wordpress"
}

variable "port" {
  type    = number
  default = 3306
}

variable "storage_encrypted" {
  type    = bool
  default = true
}

variable "final_snapshot_identifier" {
  type    = string
  default = "Ignore"
}

variable "snapshot_identifier" {
  type    = string
  default = null
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "scaling_configuration" {
  description = "Map of nested attributes with scaling properties. Only valid when engine_mode is set to `serverless`"
  type        = map(string)
  default     = {}
}

variable "cidr_vpc" {
  type = string
}