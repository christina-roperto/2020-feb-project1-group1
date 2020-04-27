variable "alb_name" {
  type = string
}

variable "alb_port" {
  type    = string
}

variable "alb_protocol" {
  type    = string
  default = "HTTP"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}
