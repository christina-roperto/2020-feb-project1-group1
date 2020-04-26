## ALB
resource "aws_alb_target_group" "main" {
  name        = var.alb_name
  port        = var.alb_port
  protocol    = var.alb_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_alb" "main" {
  name            = var.alb_name
  subnets         = var.subnet_ids
  security_groups = [aws_security_group.alb_sg.id]
}

resource "aws_alb_listener" "listener" {
  load_balancer_arn = aws_alb.main.id
  port              = var.alb_port
  protocol          = var.alb_protocol

  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }
}

### Security
resource "aws_security_group" "alb_sg" {
  description = "controls access to the ECS"

  vpc_id = var.vpc_id
  name   = "tf-ecs-sg"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}
