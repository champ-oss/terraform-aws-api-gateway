terraform {
  backend "s3" {}
  required_providers {
    keycloak = {
      source = "mrparkers/keycloak"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

locals {
  git               = "terraform-aws-api-gateway"
  keycloak_hostname = "terraform-aws-api-gateway-kc"
  hostname          = "terraform-aws-api-gateway"
}

data "aws_route53_zone" "this" {
  name = "oss.champtest.net."
}

data "aws_vpcs" "this" {
  tags = {
    purpose = "vega"
  }
}

data "aws_subnets" "private" {
  tags = {
    purpose = "vega"
    Type    = "Private"
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.this.ids[0]]
  }
}

data "aws_subnets" "public" {
  tags = {
    purpose = "vega"
    Type    = "Public"
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.this.ids[0]]
  }
}

module "hash" {
  source   = "github.com/champ-oss/terraform-git-hash.git?ref=v1.0.12-fc3bb87"
  path     = "${path.module}/../.."
  fallback = ""
}

module "acm" {
  source            = "github.com/champ-oss/terraform-aws-acm.git?ref=v1.0.111-28fcc7c"
  git               = local.git
  domain_name       = "${local.hostname}.${data.aws_route53_zone.this.name}"
  create_wildcard   = false
  zone_id           = data.aws_route53_zone.this.zone_id
  enable_validation = true
}

module "this" {
  depends_on         = [module.keycloak, module.acm, time_sleep.this]
  source             = "../../"
  git                = local.git
  certificate_arn    = module.acm.arn
  domain_name        = "${local.hostname}.${data.aws_route53_zone.this.name}"
  private_subnet_ids = data.aws_subnets.private.ids
  vpc_id             = data.aws_vpcs.this.ids[0]
  identity_sources   = ["$request.header.Authorization"]
  integration_method = "POST"
  jwt_audience       = ["account"]
  jwt_issuer         = "${module.keycloak.keycloak_endpoint}/realms/master"
  lambda_invoke_arn  = module.lambda.arn
}
