resource "aws_security_group" "dpg-amv-asg-security-group" {
  name        = "DPG AMV ASG Security Group"
  description = "DPG AMV ASG Security Group"
  vpc_id      = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port       = 80
    protocol        = "TCP"
    to_port         = 80
    security_groups = [
      var.alb_sg
    ]
    description = "DPG AMV ALB Security Group"
  }

  ingress {
    from_port       = 443
    protocol        = "TCP"
    to_port         = 443
    security_groups = [
      var.alb_sg
    ]
    description = "DPG AMV ALB Security Group"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Name        = "DPG AMV ASG Security Group"
    Project     = "DPG AMV"
    Environment = local.env
  }
}

// IAM Instance Policy
data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = [
      "sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [
        "ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "dpg_amv_instance_role" {
  name               = "dpg_amv_instance_role"
  description        = "dpg_amv_instance_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}

resource "aws_iam_instance_profile" "dpg_amv_instance_profile" {
  name = "dpg_amv_instance_profile"
  role = aws_iam_role.dpg_amv_instance_role.name
}

resource "aws_launch_template" "dpg_amv_autoscaling_launch_template" {
  name                          = "LaunchTemplate-DPG-AMV"
  image_id                      = var.ami_id
  instance_type                 = var.instance_type[local.env]
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.dpg-amv-asg-security-group.id]
  }
  iam_instance_profile {
    arn = aws_iam_instance_profile.dpg_amv_instance_profile.arn
  }

  user_data = filebase64("${path.module}/user_data.sh")
  lifecycle {
    create_before_destroy = true
  }
}

#scale up policy
resource "aws_autoscaling_policy" "dpg-amv-cpu-policy-scaleup" {
  name                      = "dpg-amv-cpu-policy-scaleup"
  autoscaling_group_name    = aws_autoscaling_group.dpg_amv_autoscaling_group.name
  adjustment_type           = "ChangeInCapacity"
  scaling_adjustment        = "1"
  cooldown                  = "300"
  policy_type               = "SimpleScaling"
}

# scale down alarm
resource "aws_autoscaling_policy" "dpg-amv-cpu-policy-scaledown" {
  name                      = "dpg-amv-cpu-policy-scaledown"
  autoscaling_group_name    = aws_autoscaling_group.dpg_amv_autoscaling_group.name
  adjustment_type           = "ChangeInCapacity"
  scaling_adjustment        = "-1"
  cooldown                  = "300"
  policy_type               = "SimpleScaling"
}

resource "aws_autoscaling_group" "dpg_amv_autoscaling_group" {
  name                      = "Autoscaling-Group-DPG-AMV-${local.env}"
  max_size                  = var.autoscaling_max[local.env]
  min_size                  = var.autoscaling_min[local.env]
  health_check_grace_period = 60
  health_check_type         = "EC2"
  desired_capacity          = var.autoscaling_api_desired_capacity[local.env]
  launch_template {
    name = aws_launch_template.dpg_amv_autoscaling_launch_template.name
  }
  vpc_zone_identifier       = [var.private_subnet_id]
  default_cooldown          = 300
  target_group_arns         = [var.target_group_arns]
  wait_for_elb_capacity     = var.autoscaling_api_desired_capacity[local.env]
  wait_for_capacity_timeout = "15m"
  termination_policies      = ["OldestLaunchConfiguration","OldestInstance"]
  lifecycle {
    create_before_destroy = true
  }

  tag {
      key                 = "Name"
      value               = "DPG AMV ASG"
      propagate_at_launch = true
    }

  tag {
      key                 = "Environment"
      value               = local.env
      propagate_at_launch = true
    }

  tag {
      key                 = "Project"
      value               = "DPG AMV"
      propagate_at_launch = true
    }

  timeouts {
    delete = "15m"
  }

  depends_on = [
    aws_launch_template.dpg_amv_autoscaling_launch_template
  ]
}
