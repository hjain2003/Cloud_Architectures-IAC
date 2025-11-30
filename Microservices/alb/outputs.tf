output "alb_arn" {
  value = aws_lb.this.arn
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_listener_arn" {
  value = aws_lb_listener.http.arn
}

output "frontend_tg_arn" {
  value = aws_lb_target_group.frontend_tg.arn
}

output "post_service_tg_arn" {
  value = aws_lb_target_group.post_service_tg.arn
}

output "comment_service_tg_arn" {
  value = aws_lb_target_group.comment_service_tg.arn
}
