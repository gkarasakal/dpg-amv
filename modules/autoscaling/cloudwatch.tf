# scale up alarm

resource "aws_cloudwatch_metric_alarm" "dpg-amv-cpu-alarm-scaleup" {
  alarm_name                = "dpg-amv-cpu-alarm-scaleup"
  alarm_description         = "dpg-amv-cpu-alarm-scaleup"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "50"
  dimensions                = {
    "AutoScalingGroupName"  = aws_autoscaling_group.dpg_amv_autoscaling_group.name
  }
  actions_enabled = true
  alarm_actions = [aws_autoscaling_policy.dpg-amv-cpu-policy-scaleup.arn]
}

resource "aws_cloudwatch_metric_alarm" "dpg-amv-cpu-alarm-scaledown" {
  alarm_name                = "dpg-amv-cpu-alarm-scaledown"
  alarm_description         = "dpg-amv-cpu-alarm-scaledown"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "20"
  dimensions                = {
    "AutoScalingGroupName"    = aws_autoscaling_group.dpg_amv_autoscaling_group.name
  }
  actions_enabled = true
  alarm_actions = [aws_autoscaling_policy.dpg-amv-cpu-policy-scaledown.arn]
}
