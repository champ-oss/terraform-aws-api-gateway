terraform {
  backend "s3" {
    bucket = "env-tfbackend-oss-backend"
    key    = "terraform-aws-api-gateway-lambda_with_jwt_and_whitelisting"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
}

data "aws_route53_zone" "this" {
  name = "oss.champtest.net."
}

# Used to test JWT auth with the API Gateway authorizer
module "keycloak" {
  source = "../shared_modules/keycloak"
}

# Deploy a Lambda for API Gateway integration
module "lambda" {
  source = "../shared_modules/python_lambda"
}

resource "random_string" "this" {
  length  = 5
  special = false
  upper   = false
  lower   = true
  numeric = true
}

locals {
  git       = "terraform-aws-api-gateway"
  hostname1 = "terraform-aws-api-gateway1-${random_string.this.result}"
  hostname2 = "terraform-aws-api-gateway2-${random_string.this.result}"
}

module "this" {
  depends_on                 = [module.keycloak]
  source                     = "../../"
  git                        = local.git
  api_gateway_v1_domain_name = "${local.hostname1}.${data.aws_route53_zone.this.name}"
  api_gateway_v2_domain_name = "${local.hostname2}.${data.aws_route53_zone.this.name}"
  zone_id                    = data.aws_route53_zone.this.zone_id
  enable_create_certificate  = true
  enable_lambda_integration  = true
  enable_api_gateway_v1      = true
  enable_api_gateway_v2      = true
  lambda_arn                 = module.lambda.arn
  identity_sources           = ["$request.header.Authorization"]
  integration_method         = "POST"
  jwt_audience               = ["account"]
  jwt_issuer                 = "${module.keycloak.keycloak_endpoint}/realms/master"
  cidr_blocks                = ["0.0.0.0/0"]
}
