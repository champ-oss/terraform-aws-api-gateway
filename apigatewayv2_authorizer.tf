resource "aws_apigatewayv2_authorizer" "this" {
  api_id           = aws_apigatewayv2_api.this.id
  authorizer_type  = "JWT"
  identity_sources = var.identity_sources
  name             = "${var.git}-${random_string.this.result}"

  jwt_configuration {
    audience = var.jwt_audience
    issuer   = var.jwt_issuer
  }
}

