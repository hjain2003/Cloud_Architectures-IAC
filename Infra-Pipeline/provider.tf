terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }

  backend "s3" {
    bucket         = "tf-state-storage-bucket123"
    key            = "ecs/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "tf_dynamo_lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}
