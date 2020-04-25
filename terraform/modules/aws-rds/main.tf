locals {
  resource_name_prefix = "${var.name_prefix}-${var.env_prefix}"
}

resource "aws_db_subnet_group" "default" {
  name       = "${local.resource_name_prefix}-${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_rds_cluster" "default" {
  cluster_identifier        = "${local.resource_name_prefix}-${var.identifier}-cluster"
  engine                    = var.engine
  engine_mode               = var.engine_mode
  engine_version            = var.engine_version
  port                      = var.port
  database_name             = var.database_name
  master_username           = data.aws_ssm_parameter.db_user.value
  master_password           = data.aws_ssm_parameter.db_password.value
  availability_zones        = var.availability_zones
  vpc_security_group_ids    = [aws_security_group.default.id]
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier
  db_subnet_group_name      = aws_db_subnet_group.default.id
  deletion_protection       = var.deletion_protection
  storage_encrypted         = var.storage_encrypted

  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.backup_window
  preferred_maintenance_window = var.maintenance_window

  dynamic "scaling_configuration" {
    for_each = length(keys(var.scaling_configuration)) == 0 ? [] : [var.scaling_configuration]

    content {
      auto_pause               = lookup(scaling_configuration.value, "auto_pause", null)
      max_capacity             = lookup(scaling_configuration.value, "max_capacity", null)
      min_capacity             = lookup(scaling_configuration.value, "min_capacity", null)
      seconds_until_auto_pause = lookup(scaling_configuration.value, "seconds_until_auto_pause", null)
      timeout_action           = lookup(scaling_configuration.value, "timeout_action", null)
    }
  }
}

resource "aws_security_group" "default" {
  name        = "${local.resource_name_prefix}-${var.identifier}-sg"
  description = "Allow RDS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_rds"
  }
}

resource "aws_ssm_parameter" "db_host" {
  name  = "PROJ1_DB_HOST"
  type  = "SecureString"
  value =  aws_rds_cluster.default.endpoint

}

resource "aws_ssm_parameter" "db_name" {
  name  = "PROJ1_DB_NAME"
  type  = "SecureString"
  value =  var.database_name

} 

data "aws_ssm_parameter" "db_user" {
  name = "PROJ1_DB_USER"
}

data "aws_ssm_parameter" "db_password" {
  name = "PROJ1_DB_PASSWORD"
}