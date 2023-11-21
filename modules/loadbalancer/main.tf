resource "aws_security_group" "dpg-amv-alb-security-group" {
  name        = "DPG AMV ALB Security Group"
  description = "DPG AMV ALB Security Group"
  vpc_id      = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port        = 80
    protocol         = "tcp"
    to_port          = 80
    cidr_blocks      = var.web_traffic

  }
  ingress {
    from_port        = 443
    protocol         = "tcp"
    to_port          = 443
    cidr_blocks      = var.web_traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name        = "DPG AMV ALB Security Group"
    Project     = "DPG AMV"
    Environment = local.env
  }
}

resource "aws_lb" "dpg_amv_alb_loadbalancer" {
  name                       = "dpg-amv-loadbalancer"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.dpg-amv-alb-security-group.id]
  subnets                    = var.subnets
}

resource "aws_lb_listener" "dpg_amv_http_listener" {
  load_balancer_arn = aws_lb.dpg_amv_alb_loadbalancer.arn
  protocol          = "HTTP"
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dpg_amv_http_target_group.arn
  }
}

// Default target group for all unmatched traffic
resource "aws_lb_target_group" "dpg_amv_http_target_group" {
  name     = "dpg-amv-http-target-group"
  port     = 80
  protocol = "HTTP"
  deregistration_delay = 600
  vpc_id   = var.vpc_id
  target_type           = "instance"
  health_check {
    path                = "/"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTP"
    interval            = 10
    matcher             = "200"
  }
}
