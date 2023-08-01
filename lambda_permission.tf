resource "aws_lambda_permission" "api_gateway_v1" {
  count         = var.enable_lambda_integration ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:${aws_api_gateway_rest_api.this.id}/*/*/"
}