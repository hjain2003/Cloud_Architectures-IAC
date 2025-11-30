output "cluster_arn" {
  description = "ECS cluster ARN"
  value       = aws_ecs_cluster.this.arn
}

output "cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.this.name
}

output "cluster_id" {
  description = "ECS cluster id"
  value       = aws_ecs_cluster.this.id
}

output "frontend_task_def_arn" {
  value       = aws_ecs_task_definition.frontend.arn
  description = "ARN of frontend task definition"
}

output "post_service_task_def_arn" {
  value       = aws_ecs_task_definition.post_service.arn
  description = "ARN of post-service task definition"
}

output "comment_service_task_def_arn" {
  value       = aws_ecs_task_definition.comment_service.arn
  description = "ARN of comment-service task definition"
}
