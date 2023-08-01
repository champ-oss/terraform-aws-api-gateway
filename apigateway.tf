resource "aws_api_gateway_rest_api" "this" {
  name                         = "${var.git}-${random_string.this.result}"
  description                  = var.description
  disable_execute_api_endpoint = var.disable_execute_api_endpoint
  tags                         = merge(local.tags, var.tags)

  endpoint_configuration {
    types = [var.endpoint_type]
  }
}

resource "aws_api_gateway_method" "this" {
  rest_api_id      = aws_api_gateway_rest_api.this.id
  resource_id      = aws_api_gateway_rest_api.this.root_resource_id
  http_method      = "ANY"
  authorization    = "NONE" # NOSONAR uses IP whitelisting
  api_key_required = var.enable_api_key
}

resource "aws_api_gateway_method_settings" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = var.logging_level
  }
}

resource "aws_api_gateway_integration" "this" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_rest_api.this.root_resource_id
  http_method             = aws_api_gateway_method.this.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.this.name}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
}

resource "aws_api_gateway_deployment" "this" {
  depends_on  = [aws_api_gateway_rest_api_policy.this]
  rest_api_id = aws_api_gateway_rest_api.this.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.this.id,
      aws_api_gateway_rest_api.this.root_resource_id,
      aws_api_gateway_method.this.id,
      aws_api_gateway_integration.this.id,
      var.cidr_blocks
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  depends_on           = [aws_api_gateway_account.this]
  deployment_id        = aws_api_gateway_deployment.this.id
  rest_api_id          = aws_api_gateway_rest_api.this.id
  stage_name           = "this"
  xray_tracing_enabled = true
  tags                 = merge(local.tags, var.tags)

  access_log_settings {
    destination_arn = "arn:aws:logs:${data.aws_region.this.name}:${data.aws_caller_identity.this.account_id}:log-group:/aws/apigateway/${aws_api_gateway_rest_api.this[0].name}"
    format = jsonencode({
      "requestId" : "$context.requestId",
      "ip" : "$context.identity.sourceIp",
      "caller" : "$context.identity.caller",
      "user" : "$context.identity.user",
      "requestTime" : "$context.requestTime",
      "httpMethod" : "$context.httpMethod",
      "resourcePath" : "$context.resourcePath",
      "status" : "$context.status",
      "protocol" : "$context.protocol",
      "responseLength" : "$context.responseLength"
    })
  }
}

resource "aws_api_gateway_domain_name" "this" {
  count                    = var.enable_domain_name ? 1 : 0
  domain_name              = var.domain_name
  tags                     = merge(local.tags, var.tags)
  regional_certificate_arn = var.enable_create_certificate ? module.acm[0].arn : var.certificate_arn
  security_policy          = "TLS_1_2"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "this" {
  count       = var.enable_domain_name ? 1 : 0
  api_id      = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  domain_name = aws_api_gateway_domain_name.this[0].domain_name
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"] # NOSONAR uses IP whitelisting
    }

    actions   = ["execute-api:Invoke"]
    resources = ["${aws_api_gateway_rest_api.this.execution_arn}*"]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = var.cidr_blocks
    }
  }
}

resource "aws_api_gateway_rest_api_policy" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  policy      = data.aws_iam_policy_document.this.json
}

resource "aws_api_gateway_account" "this" {
  cloudwatch_role_arn = aws_iam_role.this.arn
}

resource "aws_api_gateway_api_key" "this" {
  count = var.enable_api_key ? 1 : 0
  name  = "${var.git}-${random_string.this.result}"
  value = var.api_key_value
  tags  = merge(local.tags, var.tags)
}

resource "aws_api_gateway_usage_plan" "this" {
  count = var.enable_api_key ? 1 : 0
  name  = "${var.git}-${random_string.this.result}"
  tags  = merge(local.tags, var.tags)

  api_stages {
    api_id = aws_api_gateway_rest_api.this.id
    stage  = aws_api_gateway_stage.this.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "this" {
  count         = var.enable_api_key ? 1 : 0
  key_id        = aws_api_gateway_api_key.this[0].id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.this[0].id
}
