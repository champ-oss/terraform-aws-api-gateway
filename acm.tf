module "acm" {
  count             = var.enable_create_certificate ? 1 : 0
  source            = "github.com/champ-oss/terraform-aws-acm.git?ref=use-validation-arn"
  git               = var.git
  domain_name       = var.domain_name
  create_wildcard   = false
  zone_id           = var.zone_id
  enable_validation = true
  tags              = merge(local.tags, var.tags)
}