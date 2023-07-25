output "api_gateway_endpoint" {
  description = "URL endpoint of API Gateway"
  value       = "https://${local.hostname}.${data.aws_route53_zone.this.name}"
}

output "api_gateway_v1_api_key_value" {
  description = "Generated API Key to use for requests"
  sensitive   = true
  value       = module.this.api_gateway_v1_api_key_value
}