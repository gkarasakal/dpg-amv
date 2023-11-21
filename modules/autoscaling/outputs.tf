output "autoscaling_group_name" {
  value = aws_autoscaling_group.dpg_amv_autoscaling_group.name
}

output "autoscaling_group_arn" {
  value = aws_autoscaling_group.dpg_amv_autoscaling_group.arn
}

output "dpg-amv-asg-security-group" {
  value = aws_security_group.dpg-amv-asg-security-group.id
}