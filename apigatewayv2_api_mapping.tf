resource "aws_apigatewayv2_api_mapping" "this" {
  count       = var.enable_api_gateway_v2 ? 1 : 0
  api_id      = aws_apigatewayv2_api.this[0].id
  domain_name = aws_apigatewayv2_domain_name.this[0].id
  stage       = aws_apigatewayv2_stage.this[0].id
}
