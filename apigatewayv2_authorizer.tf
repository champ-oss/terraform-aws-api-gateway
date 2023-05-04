resource "aws_apigatewayv2_authorizer" "this" {
  count            = var.enable_api_gateway_v2 ? 1 : 0
  api_id           = aws_apigatewayv2_api.this[0].id
  authorizer_type  = "JWT"
  identity_sources = var.identity_sources
  name             = "${var.git}-${random_string.this.result}"

  jwt_configuration {
    audience = var.jwt_audience
    issuer   = var.jwt_issuer
  }
}

