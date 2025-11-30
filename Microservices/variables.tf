variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "ecs-mern-project"
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet ids (for ALB)"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet ids (for ECS tasks)"
  type        = list(string)
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = "ecs-cluster"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "frontend_port" {
  type        = number
  description = "Port for frontend service"
  default     = 3000
}

variable "post_service_port" {
  type        = number
  description = "Port for post-service"
  default     = 5001
}

variable "comment_service_port" {
  type        = number
  description = "Port for comment-service"
  default     = 5002
}

variable "ecs_task_execution_role_arn" {
 type = string
 default="arn:aws:iam::302263069749:role/ecsTaskExecutionRole"
 }
variable "ecs_task_role_arn" {
  type    = string
  default = ""
}

