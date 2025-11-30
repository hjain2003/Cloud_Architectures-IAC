variable "cluster_name" {
  description = "Name for the ECS cluster"
  type        = string
 }

variable "enable_container_insights" {
  description = "Enable CloudWatch Container Insights"
  type        = bool
  default     = false
}

variable "tags" {
  description = "map of tags to apply"
  type        = map(string)
  default     = {}
}

# ECR image repo URLs (pass from root or module outputs)
variable "ecr_repo_frontend_url" {
  type        = string
  description = "ECR repository URL for frontend (without tag)"
}

variable "ecr_repo_post_url" {
  type        = string
  description = "ECR repository URL for post-service (without tag)"
}

variable "ecr_repo_comment_url" {
  type        = string
  description = "ECR repository URL for comment-service (without tag)"
}

# IAM roles
variable "ecs_task_execution_role_arn" {
  type        = string
  description = "ECS task execution role ARN (must have ecr:GetAuthorizationToken, ecr:BatchGetImage, ecr:GetDownloadUrlForLayer and logs permissions)"
}

variable "ecs_task_role_arn" {
  type        = string
  description = "ECS task role ARN (optional - tasks assume this role)"
  default     = ""
}

# Ports
variable "frontend_port" {
  type    = number
  default = 3000
}

variable "post_service_port" {
  type    = number
  default = 5001
}

variable "comment_service_port" {
  type    = number
  default = 5002
}

# CPU / memory per task
variable "frontend_task_cpu" {
  type    = string
  default = "256"
}

variable "frontend_task_memory" {
  type    = string
  default = "512"
}

variable "post_task_cpu" {
  type    = string
  default = "256"
}

variable "post_task_memory" {
  type    = string
  default = "512"
}

variable "comment_task_cpu" {
  type    = string
  default = "256"
}

variable "comment_task_memory" {
  type    = string
  default = "512"
}
