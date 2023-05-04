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
  source = "../shared_modules/keycloak"
}

# Deploy an ECS service behind an ALB for API Gateway integration
module "lb_ecs" {
  source = "../shared_modules/lb_ecs"
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
  api_gateway_v2_domain_name               = "${local.hostname}.${data.aws_route53_zone.this.name}"
  zone_id                   = data.aws_route53_zone.this.zone_id
  enable_create_certificate = true
  enable_lb_integration     = true
  enable_api_gateway_v2     = true
  lb_listener_arn           = module.lb_ecs.lb_private_listener_arn
  private_subnet_ids        = module.lb_ecs.private_subnet_ids
  security_group_ids        = [module.lb_ecs.ecs_app_security_group]
  identity_sources          = ["$request.header.Authorization"]
  integration_method        = "POST"
  jwt_audience              = ["account"]
  jwt_issuer                = "${module.keycloak.keycloak_endpoint}/realms/master"
  lb_domain_name            = module.lb_ecs.dns_name
}
