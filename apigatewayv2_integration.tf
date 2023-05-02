# Lambda integration
resource "aws_apigatewayv2_integration" "lambda" {
  count              = var.enable_lambda_integration ? 1 : 0
  api_id             = aws_apigatewayv2_api.this.id
  integration_type   = "AWS_PROXY"
  integration_method = var.integration_method
  integration_uri    = var.lambda_invoke_arn
  connection_type    = "INTERNET"
}

# Application Load Balancer integration
resource "aws_apigatewayv2_integration" "lb" {
  count              = var.enable_lb_integration ? 1 : 0
  api_id             = aws_apigatewayv2_api.this.id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = var.lb_listener_arn
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.this[0].id

  tls_config {
    server_name_to_verify = var.domain_name
  }

  request_parameters = {
    "overwrite:header.host" = var.domain_name
  }
}