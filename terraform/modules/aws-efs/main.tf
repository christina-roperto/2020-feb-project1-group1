resource "aws_efs_file_system" "project_1" {
  creation_token = "wordpress"
  encrypted ="false"

  tags = {
    Name = var.project_name
  }
}

resource "aws_efs_mount_target" "project_1" {
  count          = length(var.subnet_ids)
  subnet_id      = var.subnet_ids[count.index]
  file_system_id = aws_efs_file_system.project_1.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_security_group" "efs_sg" {
  description = "controls access to the EFS"

  vpc_id = var.vpc_id
  name   = "tf-efs-sg"

  ingress {
    protocol    = "tcp"
    from_port   = 2049
    to_port     = 2049
    security_groups = [var.sg_id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
}