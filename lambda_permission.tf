resource "aws_lambda_permission" "api_gateway_v1" {
  count         = var.enable_lambda_integration && var.enable_api_gateway_v1 ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_invoke_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:${aws_api_gateway_rest_api.this[0].id}/*/${aws_api_gateway_method.this[0].http_method}${aws_api_gateway_resource.this[0].path}"
}

resource "aws_lambda_permission" "api_gateway_v2" {
  count         = var.enable_lambda_integration && var.enable_api_gateway_v2 ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_invoke_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this[0].execution_arn}/*"
}