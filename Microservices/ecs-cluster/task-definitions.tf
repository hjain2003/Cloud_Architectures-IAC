# ---------- Frontend task definition ----------
resource "aws_ecs_task_definition" "frontend" {
  family                   = "frontend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.frontend_task_cpu
  memory                   = var.frontend_task_memory
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = "${var.ecr_repo_frontend_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.frontend_port
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# ---------- Post-service task definition ----------
resource "aws_ecs_task_definition" "post_service" {
  family                   = "post-service-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.post_task_cpu
  memory                   = var.post_task_memory
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = "post-service"
      image     = "${var.ecr_repo_post_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.post_service_port
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# ---------- Comment-service task definition ----------
resource "aws_ecs_task_definition" "comment_service" {
  family                   = "comment-service-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.comment_task_cpu
  memory                   = var.comment_task_memory
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = "comment-service"
      image     = "${var.ecr_repo_comment_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.comment_service_port
          protocol      = "tcp"
        }
      ]
    }
  ])
}
