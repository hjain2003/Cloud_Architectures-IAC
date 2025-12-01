output "kinesis_stream_name" {
  value = aws_kinesis_stream.orders.name
}

output "projection_table_name" {
  value = aws_dynamodb_table.projection.name
}

output "producer_lambda_name" {
  value = aws_lambda_function.producer.function_name
}

output "consumer_lambda_name" {
  value = aws_lambda_function.consumer.function_name
}
