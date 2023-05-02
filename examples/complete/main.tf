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

