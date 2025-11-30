variable "region" {
  type        = string
  description = "AWS region"
}

variable "queue_name" {
  type        = string
  default     = "event-driven-demo-queue"
}
