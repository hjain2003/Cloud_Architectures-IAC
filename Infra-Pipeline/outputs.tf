output "cluster_arn" {
  value       = module.ecs_cluster.cluster_arn
  description = "ECS cluster ARN"
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = module.alb.alb_arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.alb_dns_name
}

output "alb_listener_arn" {
  description = "ARN of the HTTP listener for the ALB"
  value       = module.alb.alb_listener_arn
}

output "frontend_tg_arn" {
  description = "Target Group ARN for the frontend service"
  value       = module.alb.frontend_tg_arn
}

output "post_service_tg_arn" {
  description = "Target Group ARN for the post service"
  value       = module.alb.post_service_tg_arn
}

output "comment_service_tg_arn" {
  description = "Target Group ARN for the comment service"
  value       = module.alb.comment_service_tg_arn
}

