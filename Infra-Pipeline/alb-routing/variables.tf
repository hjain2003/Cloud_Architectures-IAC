variable "vpc_id" {
  type = string
}

variable "alb_arn" {
  type = string
}

variable "alb_listener_arn" {
  type = string
}

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
