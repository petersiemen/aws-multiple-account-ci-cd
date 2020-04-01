output "lambda_function_arn" {
  value = aws_lambda_function.lambda-api-gateway.arn
}

output "lambda_function_invoke_arn" {
  value = aws_lambda_function.lambda-api-gateway.invoke_arn
}

output "lambda_function_name" {
  value = aws_lambda_function.lambda-api-gateway.id
}