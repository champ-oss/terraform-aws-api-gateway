resource "aws_apigatewayv2_api" "this" {
  description                  = var.description
  disable_execute_api_endpoint = var.disable_execute_api_endpoint
  name                         = "${var.git}-${random_string.this.result}"
  protocol_type                = "HTTP"
  tags                         = merge(local.tags, var.tags)

  cors_configuration {
    allow_credentials = var.cors_configuration_allow_credentials
    allow_headers     = var.cors_configuration_allow_headers
    allow_methods     = var.cors_configuration_allow_methods
    allow_origins     = var.cors_configuration_allow_origins
    expose_headers    = var.cors_configuration_expose_headers
    max_age           = var.cors_configuration_max_age
  }
}