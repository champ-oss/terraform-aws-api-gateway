#resource "aws_lambda_permission" "api_gateway_v1" {
#  count         = var.enable_lambda_integration && var.enable_api_gateway_v1 ? 1 : 0
#  function_name = "${var.lambda_arn}"
#  statement_id  = "AllowExecutionFromApiGateway"
#  action        = "lambda:InvokeFunction"
#  principal     = "apigateway.amazonaws.com"
#  source_arn    = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${var.method}${aws_api_gateway_resource.proxy.path}"
#  depends_on    = ["aws_api_gateway_rest_api.api", "aws_api_gateway_resource.proxy"]
#}

resource "aws_lambda_permission" "api_gateway_v2" {
  count         = var.enable_lambda_integration && var.enable_api_gateway_v2 ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_invoke_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this[0].execution_arn}/*"
}