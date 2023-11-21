output "dpg_amv_http_target_group" {
value = aws_lb_target_group.dpg_amv_http_target_group.arn
}

output "dpg_amv_alb_loadbalancer_arn" {
  value = aws_lb.dpg_amv_alb_loadbalancer.arn
}

output "dpg_amv_alb_sg_id" {
  value = aws_security_group.dpg-amv-alb-security-group.id
}
