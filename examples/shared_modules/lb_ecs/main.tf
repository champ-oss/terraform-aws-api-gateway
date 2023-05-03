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

locals {
  git      = "terraform-aws-api-gateway"
  hostname = "terraform-aws-api-gateway-${random_string.this.result}"
}

resource "random_string" "this" {
  length  = 5
  special = false
  upper   = false
  lower   = true
  numeric = true
}

module "acm" {
  source            = "github.com/champ-oss/terraform-aws-acm.git?ref=v1.0.111-28fcc7c"
  git               = local.git
  domain_name       = "${local.hostname}.${data.aws_route53_zone.this.name}"
  create_wildcard   = false
  zone_id           = data.aws_route53_zone.this.zone_id
  enable_validation = true
}

module "core" {
  source                    = "github.com/champ-oss/terraform-aws-core.git?ref=v1.0.113-55c4641"
  git                       = local.git
  name                      = local.git
  vpc_id                    = data.aws_vpcs.this.ids[0]
  public_subnet_ids         = data.aws_subnets.public.ids
  private_subnet_ids        = data.aws_subnets.private.ids
  protect                   = false
  log_retention             = 3
  certificate_arn           = module.acm.arn
  enable_container_insights = false
}

module "app" {
  source                            = "github.com/champ-oss/terraform-aws-app?ref=v1.0.190-637e28e"
  git                               = local.git
  vpc_id                            = data.aws_vpcs.this.ids[0]
  subnets                           = data.aws_subnets.private.ids
  zone_id                           = data.aws_route53_zone.this.zone_id
  cluster                           = module.core.ecs_cluster_name
  security_groups                   = [module.core.ecs_app_security_group]
  execution_role_arn                = module.core.execution_ecs_role_arn
  listener_arn                      = module.core.lb_private_listener_arn
  lb_dns_name                       = module.core.lb_private_dns_name
  lb_zone_id                        = module.core.lb_private_zone_id
  enable_route53                    = true
  name                              = "test"
  dns_name                          = "${local.hostname}.${data.aws_route53_zone.this.name}"
  image                             = "testcontainers/helloworld"
  healthcheck                       = "/"
  port                              = 8080
  health_check_grace_period_seconds = 5
  deregistration_delay              = 5
  retention_in_days                 = 3
}
