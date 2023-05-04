resource "aws_route53_record" "api_gateway_v2" {
  count   = var.enable_api_gateway_v2 ? 1 : 0
  name    = aws_apigatewayv2_domain_name.this[0].domain_name
  type    = "A"
  zone_id = var.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}