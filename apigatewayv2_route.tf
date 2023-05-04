resource "aws_apigatewayv2_route" "lambda" {
  count              = var.enable_lambda_integration && var.enable_api_gateway_v2 ? 1 : 0
  api_id             = aws_apigatewayv2_api.this[0].id
  route_key          = "$default"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.this[0].id
  target             = "integrations/${aws_apigatewayv2_integration.lambda[0].id}"
}

resource "aws_apigatewayv2_route" "lb" {
  count              = var.enable_lb_integration && var.enable_api_gateway_v2 ? 1 : 0
  api_id             = aws_apigatewayv2_api.this[0].id
  route_key          = "$default"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.this[0].id
  target             = "integrations/${aws_apigatewayv2_integration.lb[0].id}"
}
