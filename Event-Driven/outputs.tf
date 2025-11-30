output "queue_url" {
  value = aws_sqs_queue.event_queue.url
}

output "producer_lambda" {
  value = aws_lambda_function.producer.function_name
}

output "consumer_lambda" {
  value = aws_lambda_function.consumer.function_name
}
