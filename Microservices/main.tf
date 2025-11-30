module "ecs_cluster" {
  source                = "./ecs-cluster"
  cluster_name          = var.cluster_name
  tags                  = var.tags
  ecr_repo_frontend_url = module.ecr_repos.frontend_repo_url
  ecr_repo_post_url     = module.ecr_repos.post_service_repo_url
  ecr_repo_comment_url  = module.ecr_repos.comment_service_repo_url

  ecs_task_execution_role_arn = var.ecs_task_execution_role_arn
  ecs_task_role_arn           = var.ecs_task_role_arn
}

module "ecr_repos" {
  source = "./ecr-repos"
}

module "alb" {
  source               = "./alb"
  vpc_id               = var.vpc_id
  public_subnet_ids    = var.public_subnet_ids
  frontend_port        = var.frontend_port
  post_service_port    = var.post_service_port
  comment_service_port = var.comment_service_port
}


