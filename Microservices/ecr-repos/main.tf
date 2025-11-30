resource "aws_ecr_repository" "frontend" {
  name = "frontend-repo"
}

resource "aws_ecr_repository" "post_service" {
  name = "post-service-repo"
}

resource "aws_ecr_repository" "comment_service" {
  name = "comment-service-repo"
}
