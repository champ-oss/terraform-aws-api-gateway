locals {
  git      = "terraform-aws-api-gateway"
  hostname = "terraform-aws-api-gateway-${random_string.this.result}"
}

data "aws_route53_zone" "this" {
  name = "oss.champtest.net."
}

resource "random_string" "this" {
  length  = 5
  special = false
  upper   = false
  lower   = true
  numeric = true
}

module "this" {
  source                    = "../../"
  git                       = local.git
  domain_name               = "${local.hostname}.${data.aws_route53_zone.this.name}"
  zone_id                   = data.aws_route53_zone.this.zone_id
  enable_create_certificate = true
  cidr_blocks               = ["0.0.0.0/0"]
  enable_api_key            = true
  api_gateway_deployment_id = aws_api_gateway_deployment.this.id
}

data "archive_file" "this" {
  type        = "zip"
  source_file = "${path.module}/app.py"
  output_path = "package.zip"
}

module "lambda1" {
  source                         = "github.com/champ-oss/terraform-aws-lambda.git?ref=v1.0.137-616e273"
  git                            = "terraform-aws-api-gateway"
  name                           = "lambda1"
  filename                       = data.archive_file.this.output_path
  source_code_hash               = data.archive_file.this.output_base64sha256
  handler                        = "app.handler"
  runtime                        = "python3.9"
  reserved_concurrent_executions = 1

  # attach the lambda to the root of API Gateway
  enable_api_gateway_v1           = true
  create_api_gateway_v1_resource  = false
  api_gateway_v1_api_key_required = true
  api_gateway_v1_rest_api_id      = module.this.rest_api_id
  api_gateway_v1_resource_id      = module.this.root_resource_id
  api_gateway_v1_http_method      = "GET"
  api_gateway_v1_resource_path    = "/"
}

module "lambda2" {
  source                         = "github.com/champ-oss/terraform-aws-lambda.git?ref=v1.0.137-616e273"
  git                            = "terraform-aws-api-gateway"
  name                           = "lambda2"
  filename                       = data.archive_file.this.output_path
  source_code_hash               = data.archive_file.this.output_base64sha256
  handler                        = "app.handler"
  runtime                        = "python3.9"
  reserved_concurrent_executions = 1

  # attach the lambda to /test path of API Gateway
  enable_api_gateway_v1             = true
  api_gateway_v1_api_key_required   = true
  api_gateway_v1_rest_api_id        = module.this.rest_api_id
  api_gateway_v1_parent_resource_id = module.this.root_resource_id
  api_gateway_v1_path_part          = "test"
  api_gateway_v1_http_method        = "GET"
}

resource "aws_api_gateway_deployment" "this" {
  depends_on  = [module.lambda1, module.lambda2]
  rest_api_id = module.this.rest_api_id
  triggers = {
    redeployment = sha1(jsonencode([
      module.this.root_resource_id,
      module.lambda1.api_gateway_v1_resource_id,
      module.lambda1.api_gateway_v1_method_id,
      module.lambda1.api_gateway_v1_integration_id,
      module.lambda2.api_gateway_v1_resource_id,
      module.lambda2.api_gateway_v1_method_id,
      module.lambda2.api_gateway_v1_integration_id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "root_endpoint" {
  description = "URL endpoint of API Gateway"
  value       = "https://${local.hostname}.${data.aws_route53_zone.this.name}"
}

output "test_path_endpoint" {
  description = "URL endpoint of API Gateway with test path"
  value       = "https://${local.hostname}.${data.aws_route53_zone.this.name}/test"
}

output "api_key_value" {
  description = "Generated API Key to use for requests"
  sensitive   = true
  value       = module.this.api_key_value
}