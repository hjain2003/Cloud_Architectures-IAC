terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Kinesis stream (event store)
resource "aws_kinesis_stream" "orders" {
  name        = "orders-stream"
  shard_count = 1
}

# Projection table (DynamoDB)
resource "aws_dynamodb_table" "projection" {
  name         = "orders-projection"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "orderId"

  attribute {
    name = "orderId"
    type = "S"
  }
}

# IAM role used by both Lambdas (demo convenience)
resource "aws_iam_role" "lambda_role" {
  name = "lambda-event-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda-event-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kinesis:PutRecord",
          "kinesis:PutRecords",
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:DescribeStream",
          "kinesis:ListShards"
        ],
        Resource = aws_kinesis_stream.orders.arn
      },
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:GetItem"
        ],
        Resource = aws_dynamodb_table.projection.arn
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

# Producer Lambda
resource "aws_lambda_function" "producer" {
  function_name = "order-producer"
  role          = aws_iam_role.lambda_role.arn
  handler       = "producer.lambda_handler"
  runtime       = "python3.11"
  filename      = "${path.module}/lambda_producer/producer.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_producer/producer.zip")

  environment {
    variables = {
      STREAM_NAME = aws_kinesis_stream.orders.name
    }
  }
}

# Consumer Lambda
resource "aws_lambda_function" "consumer" {
  function_name = "order-consumer"
  role          = aws_iam_role.lambda_role.arn
  handler       = "consumer.lambda_handler"
  runtime       = "python3.11"
  filename      = "${path.module}/lambda_consumer/consumer.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_consumer/consumer.zip")

  environment {
    variables = {
      PROJECTION_TABLE = aws_dynamodb_table.projection.name
    }
  }
}

# Kinesis -> Lambda mapping (consumer)
resource "aws_lambda_event_source_mapping" "kinesis_to_consumer" {
  event_source_arn  = aws_kinesis_stream.orders.arn
  function_name     = aws_lambda_function.consumer.arn
  starting_position = "TRIM_HORIZON"
  batch_size        = 100
  enabled           = true
}
