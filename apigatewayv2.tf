resource "aws_apigatewayv2_api" "this" {
  count                        = var.enable_api_gateway_v2 ? 1 : 0
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

resource "aws_apigatewayv2_integration" "lambda" {
  count              = var.enable_lambda_integration && var.enable_api_gateway_v2 ? 1 : 0
  api_id             = aws_apigatewayv2_api.this[0].id
  integration_type   = "AWS_PROXY"
  integration_method = var.integration_method
  integration_uri    = var.lambda_arn
  connection_type    = "INTERNET"
}

resource "aws_apigatewayv2_integration" "lb" {
  count              = var.enable_lb_integration && var.enable_api_gateway_v2 ? 1 : 0
  api_id             = aws_apigatewayv2_api.this[0].id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = var.lb_listener_arn
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.this[0].id

  tls_config {
    server_name_to_verify = var.lb_domain_name
  }

  request_parameters = {
    "overwrite:header.host" = var.lb_domain_name
  }
}

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

resource "aws_apigatewayv2_stage" "this" {
  count       = var.enable_api_gateway_v2 ? 1 : 0
  api_id      = aws_apigatewayv2_api.this[0].id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.this.arn
    format = jsonencode(
      {
        httpMethod     = "$context.httpMethod"
        ip             = "$context.identity.sourceIp"
        protocol       = "$context.protocol"
        requestId      = "$context.requestId"
        requestTime    = "$context.requestTime"
        responseLength = "$context.responseLength"
        routeKey       = "$context.routeKey"
        status         = "$context.status"
      }
    )
  }
}

resource "aws_apigatewayv2_domain_name" "this" {
  count       = var.enable_api_gateway_v2 && var.api_gateway_v2_domain_name != null ? 1 : 0
  domain_name = var.api_gateway_v2_domain_name
  tags        = merge(local.tags, var.tags)

  domain_name_configuration {
    certificate_arn = var.enable_create_certificate ? module.acm[0].arn : var.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "this" {
  count       = var.enable_api_gateway_v2 && var.api_gateway_v2_domain_name != null ? 1 : 0
  api_id      = aws_apigatewayv2_api.this[0].id
  domain_name = aws_apigatewayv2_domain_name.this[0].id
  stage       = aws_apigatewayv2_stage.this[0].id
}

resource "aws_apigatewayv2_vpc_link" "this" {
  count              = var.enable_lb_integration && var.enable_api_gateway_v2 ? 1 : 0
  name               = "${var.git}-${random_string.this.result}"
  security_group_ids = var.security_group_ids
  subnet_ids         = var.private_subnet_ids
  tags               = merge(local.tags, var.tags)
}