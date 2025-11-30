output "frontend_repo_url" {
  value = aws_ecr_repository.frontend.repository_url
}

output "post_service_repo_url" {
  value = aws_ecr_repository.post_service.repository_url
}

output "comment_service_repo_url" {
  value = aws_ecr_repository.comment_service.repository_url
}
