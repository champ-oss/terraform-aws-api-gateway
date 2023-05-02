data "archive_file" "this" {
  type        = "zip"
  source_file = "${path.module}/app.py"
  output_path = "package.zip"
}

# Deploy a Lambda for API Gateway integration
module "lambda" {
  source                         = "github.com/champ-oss/terraform-aws-lambda.git?ref=v1.0.116-111a99f"
  git                            = local.git
  name                           = "lambda"
  filename                       = data.archive_file.this.output_path
  source_code_hash               = data.archive_file.this.output_base64sha256
  handler                        = "app.handler"
  runtime                        = "python3.9"
  reserved_concurrent_executions = 1
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
  zone_id            = data.aws_route53_zone.this.zone_id

  # Configuration for Keycloak JWT + Lambda integration
  enable_lambda_integration = true
  lambda_invoke_arn         = module.lambda.arn
  identity_sources          = ["$request.header.Authorization"]
  integration_method        = "POST"
  jwt_audience              = ["account"]
  jwt_issuer                = "${module.keycloak.keycloak_endpoint}/realms/master"
}
