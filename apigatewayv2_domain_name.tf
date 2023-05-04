resource "aws_apigatewayv2_domain_name" "this" {
  count       = var.enable_api_gateway_v2 ? 1 : 0
  domain_name = var.domain_name
  tags        = merge(local.tags, var.tags)

  domain_name_configuration {
    certificate_arn = var.enable_create_certificate ? module.acm[0].arn : var.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}
