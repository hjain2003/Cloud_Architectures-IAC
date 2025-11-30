output "frontend_tg_arn" {
  value = aws_lb_target_group.frontend_tg.arn
}

output "post_service_tg_arn" {
  value = aws_lb_target_group.post_service_tg.arn
}

output "comment_service_tg_arn" {
  value = aws_lb_target_group.comment_service_tg.arn
}


