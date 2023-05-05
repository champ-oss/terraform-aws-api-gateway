output "api_gateway_endpoint" {
  description = "URL endpoint of API Gateway"
  value       = "https://${local.hostname}.${data.aws_route53_zone.this.name}"
}
