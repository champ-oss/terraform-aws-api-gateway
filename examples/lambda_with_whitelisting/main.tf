terraform {
  backend "s3" {
    bucket = "env-tfbackend-oss-backend"
    key    = "terraform-aws-api-gateway-lambda_with_whitelisting"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
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

locals {
  git      = "terraform-aws-api-gateway"
  hostname = "terraform-aws-api-gateway-${random_string.this.result}"
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

# Deploy Lambdas for API Gateway integration
module "lambda1" {
  source                         = "github.com/champ-oss/terraform-aws-lambda.git?ref=remove-api-gateway-deployment"
  git                            = "terraform-aws-api-gateway"
  name                           = "lambda1"
  filename                       = data.archive_file.this.output_path
  source_code_hash               = data.archive_file.this.output_base64sha256
  handler                        = "app.handler"
  runtime                        = "python3.9"
  reserved_concurrent_executions = 1
  enable_api_gateway_v1          = true
  create_api_gateway_v1_resource = false
  api_gateway_v1_rest_api_id     = module.this.rest_api_id
  api_gateway_v1_resource_id     = module.this.root_resource_id
  api_gateway_v1_http_method     = "GET"
  api_gateway_v1_resource_path   = "/"
}

module "lambda2" {
  source                            = "github.com/champ-oss/terraform-aws-lambda.git?ref=remove-api-gateway-deployment"
  git                               = "terraform-aws-api-gateway"
  name                              = "lambda2"
  filename                          = data.archive_file.this.output_path
  source_code_hash                  = data.archive_file.this.output_base64sha256
  handler                           = "app.handler"
  runtime                           = "python3.9"
  reserved_concurrent_executions    = 1
  enable_api_gateway_v1             = true
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