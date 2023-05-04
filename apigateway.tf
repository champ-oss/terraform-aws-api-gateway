resource "aws_api_gateway_rest_api" "this" {
  count                        = var.enable_api_gateway_v1 ? 1 : 0
  name                         = "${var.git}-${random_string.this.result}"
  description                  = var.description
  disable_execute_api_endpoint = var.disable_execute_api_endpoint
  tags                         = merge(local.tags, var.tags)
}

resource "aws_api_gateway_method" "this" {
  count         = var.enable_api_gateway_v1 ? 1 : 0
  rest_api_id   = aws_api_gateway_rest_api.this[0].id
  resource_id   = aws_api_gateway_rest_api.this[0].root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "this" {
  count                   = var.enable_api_gateway_v1 ? 1 : 0
  rest_api_id             = aws_api_gateway_rest_api.this[0].id
  resource_id             = aws_api_gateway_rest_api.this[0].root_resource_id
  http_method             = aws_api_gateway_method.this[0].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.this.name}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
}

resource "aws_api_gateway_deployment" "this" {
  depends_on  = [aws_api_gateway_rest_api_policy.this]
  count       = var.enable_api_gateway_v1 ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.this[0].id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.this[0].id,
      aws_api_gateway_rest_api.this[0].root_resource_id,
      aws_api_gateway_method.this[0].id,
      aws_api_gateway_integration.this[0].id,
      var.cidr_blocks
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

resource "aws_api_gateway_domain_name" "this" {
  count                    = var.enable_api_gateway_v1 ? 1 : 0
  domain_name              = var.domain_name
  tags                     = merge(local.tags, var.tags)
  regional_certificate_arn = var.enable_create_certificate ? module.acm[0].arn : var.certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "this" {
  count       = var.enable_api_gateway_v1 ? 1 : 0
  api_id      = aws_api_gateway_rest_api.this[0].id
  stage_name  = aws_api_gateway_stage.this[0].stage_name
  domain_name = aws_api_gateway_domain_name.this[0].domain_name
}

data "aws_iam_policy_document" "this" {
  count = var.enable_api_gateway_v1 ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions   = ["execute-api:Invoke"]
    resources = ["${aws_api_gateway_rest_api.this[0].execution_arn}*"]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = var.cidr_blocks
    }
  }
}
resource "aws_api_gateway_rest_api_policy" "this" {
  count       = var.enable_api_gateway_v1 ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.this[0].id
  policy      = data.aws_iam_policy_document.this[0].json
}
