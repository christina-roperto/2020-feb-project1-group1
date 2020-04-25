variable "project_name" {
  type = string
  description = "Project name to be used when naming resources."
}

variable "alert_sms" {
  type = string
  description = "Mobile number that will receive alerts, example: +614xxxxxxxx"
}

variable "rds_cluster_id" {
  type = string
  description = "RDS cluster to monitor"
}
