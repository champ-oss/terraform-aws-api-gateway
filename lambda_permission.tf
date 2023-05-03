resource "aws_lambda_permission" "this" {
  count         = var.enable_lambda_integration ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_invoke_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*"
}