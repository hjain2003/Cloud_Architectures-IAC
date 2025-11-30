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

# -----------------------------
# SQS Queue
# -----------------------------
resource "aws_sqs_queue" "event_queue" {
  name                      = var.queue_name
  visibility_timeout_seconds = 30
}

# -----------------------------
# Producer Lambda Role & Policy
# -----------------------------
resource "aws_iam_role" "producer_role" {
  name = "producer-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
      }
    ]
  })
}

resource "aws_iam_policy" "producer_policy" {
  name = "producer-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["sqs:SendMessage"]
        Resource = aws_sqs_queue.event_queue.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "producer_policy_attach" {
  role       = aws_iam_role.producer_role.name
  policy_arn = aws_iam_policy.producer_policy.arn
}

# Producer Lambda
resource "aws_lambda_function" "producer" {
  function_name = "producer-lambda"
  filename      = "${path.module}/lambda_producer/producer.zip"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  role          = aws_iam_role.producer_role.arn

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.event_queue.url
    }
  }
}

# -----------------------------
# Consumer Lambda
# -----------------------------
resource "aws_iam_role" "consumer_role" {
  name = "consumer-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
      }
    ]
  })
}

resource "aws_iam_policy" "consumer_policy" {
  name = "consumer-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
        Resource = aws_sqs_queue.event_queue.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "consumer_policy_attach" {
  role       = aws_iam_role.consumer_role.name
  policy_arn = aws_iam_policy.consumer_policy.arn
}

# Consumer Lambda function
resource "aws_lambda_function" "consumer" {
  function_name = "consumer-lambda"
  filename      = "${path.module}/lambda_consumer/consumer.zip"
  handler       = "lambda_function.handler"
  runtime       = "python3.11"
  role          = aws_iam_role.consumer_role.arn
}

# -----------------------------
# SQS → Lambda Trigger
# -----------------------------
resource "aws_lambda_event_source_mapping" "sqs_to_consumer" {
  event_source_arn = aws_sqs_queue.event_queue.arn
  function_name    = aws_lambda_function.consumer.arn
  batch_size       = 1
  enabled          = true
}

# -----------------------------
# CloudWatch Log Groups
# -----------------------------
resource "aws_cloudwatch_log_group" "producer_lg" {
  name              = "/aws/lambda/producer-lambda"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "consumer_lg" {
  name              = "/aws/lambda/consumer-lambda"
  retention_in_days = 7
}
