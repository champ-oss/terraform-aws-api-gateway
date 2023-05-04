resource "aws_api_gateway_rest_api" "this" {
  count                        = var.enable_api_gateway_v1 ? 1 : 0
  name                         = "${var.git}-${random_string.this.result}"
  description                  = var.description
  disable_execute_api_endpoint = var.disable_execute_api_endpoint
  tags                         = merge(local.tags, var.tags)
}

resource "aws_api_gateway_resource" "this" {
  count       = var.enable_api_gateway_v1 ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.this[0].id
  parent_id   = aws_api_gateway_rest_api.this[0].root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "this" {
  count         = var.enable_api_gateway_v1 ? 1 : 0
  rest_api_id   = aws_api_gateway_rest_api.this[0].id
  resource_id   = aws_api_gateway_resource.this[0].id
  http_method   = var.integration_method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "this" {
  count                   = var.enable_api_gateway_v1 ? 1 : 0
  rest_api_id             = aws_api_gateway_rest_api.this[0].id
  resource_id             = aws_api_gateway_resource.this[0].id
  http_method             = aws_api_gateway_method.this[0].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_deployment" "this" {
  count       = var.enable_api_gateway_v1 ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.this[0].id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.this[0].id,
      aws_api_gateway_method.this[0].id,
      aws_api_gateway_integration.this[0].id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  count         = var.enable_api_gateway_v1 ? 1 : 0
  deployment_id = aws_api_gateway_deployment.this[0].id
  rest_api_id   = aws_api_gateway_rest_api.this[0].id
  stage_name    = "this"
}

