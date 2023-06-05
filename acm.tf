module "acm_api_gateway_v1" {
  count             = var.enable_create_certificate && var.enable_api_gateway_v1 ? 1 : 0
  source            = "github.com/champ-oss/terraform-aws-acm.git?ref=v1.0.111-28fcc7c"
  git               = var.git
  domain_name       = var.api_gateway_v1_domain_name
  create_wildcard   = false
  zone_id           = var.zone_id
  enable_validation = true
  time_sleep        = 60
  tags              = merge(local.tags, var.tags)
}

module "acm_api_gateway_v2" {
  count             = var.enable_create_certificate && var.enable_api_gateway_v2 ? 1 : 0
  source            = "github.com/champ-oss/terraform-aws-acm.git?ref=v1.0.111-28fcc7c"
  git               = var.git
  domain_name       = var.api_gateway_v2_domain_name
  create_wildcard   = false
  zone_id           = var.zone_id
  enable_validation = true
  time_sleep        = 60
  tags              = merge(local.tags, var.tags)
}
