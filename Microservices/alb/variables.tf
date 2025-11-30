variable "vpc_id" {
  type        = string
  description = "VPC ID where ALB will be created"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for ALB"
}

variable "frontend_port" {
  type        = number
  default     = 3000
}

variable "post_service_port" {
  type        = number
  default     = 5001
}

variable "comment_service_port" {
  type        = number
  default     = 5002
}
