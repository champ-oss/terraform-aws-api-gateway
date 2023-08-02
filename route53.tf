resource "aws_route53_record" "api_gateway_v1" {
  count   = var.enable_domain_name ? 1 : 0
  name    = aws_api_gateway_domain_name.this[0].domain_name
  type    = "A"
  zone_id = var.zone_id

  alias {
    name                   = aws_api_gateway_domain_name.this[0].regional_domain_name
    zone_id                = aws_api_gateway_domain_name.this[0].regional_zone_id
    evaluate_target_health = false
  }
}