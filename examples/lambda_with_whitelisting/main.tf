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
  git      = "terraform-aws-api-gateway"
  hostname = "terraform-aws-api-gateway-${random_string.this.result}"
}

module "this" {
  source                    = "../../"
  git                       = local.git
  domain_name               = "${local.hostname}.${data.aws_route53_zone.this.name}"
  zone_id                   = data.aws_route53_zone.this.zone_id
  enable_create_certificate = true
  enable_lambda_integration = true
  lambda_arn                = module.lambda.arn
  cidr_blocks               = ["0.0.0.0/0"]
  enable_api_key            = true
}
