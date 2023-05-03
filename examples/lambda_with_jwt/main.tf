terraform {
  backend "s3" {}
}

provider "aws" {
  region = "us-east-2"
}

data "aws_route53_zone" "this" {
  name = "oss.champtest.net."
}

# Used to test JWT auth with the API Gateway authorizer
module "keycloak" {
  source = "../keycloak"
}

# Deploy a Lambda for API Gateway integration
module "lambda" {
  source = "../python_lambda"
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
  depends_on                = [module.keycloak]
  source                    = "../../"
  git                       = local.git
  domain_name               = "${local.hostname}.${data.aws_route53_zone.this.name}"
  zone_id                   = data.aws_route53_zone.this.zone_id
  enable_create_certificate = true
  enable_lambda_integration = true
  lambda_invoke_arn         = module.lambda.arn
  identity_sources          = ["$request.header.Authorization"]
  integration_method        = "POST"
  jwt_audience              = ["account"]
  jwt_issuer                = "${module.keycloak.keycloak_endpoint}/realms/master"
}
