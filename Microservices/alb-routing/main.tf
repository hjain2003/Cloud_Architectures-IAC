# --- Target Groups ---

resource "aws_lb_target_group" "frontend_tg" {
  name        = "frontend-tg"
  port        = var.frontend_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

resource "aws_lb_target_group" "post_service_tg" {
  name        = "post-service-tg"
  port        = var.post_service_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/api/post/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

resource "aws_lb_target_group" "comment_service_tg" {
  name        = "comment-service-tg"
  port        = var.comment_service_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/api/comment/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

# --- Listener Rules ---

# Post-service
resource "aws_lb_listener_rule" "post_rule" {
  listener_arn = var.alb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.post_service_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/post/*"]
    }
  }
}

# Comment-service
resource "aws_lb_listener_rule" "comment_rule" {
  listener_arn = var.alb_listener_arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.comment_service_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/comment/*"]
    }
  }
}

