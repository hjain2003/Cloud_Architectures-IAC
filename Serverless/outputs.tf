output "lambda_function_name" {
  value = aws_lambda_function.serverless_function.function_name
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.serverless_table.name
}

output "api_gateway_url" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}
