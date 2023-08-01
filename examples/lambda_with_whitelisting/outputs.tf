output "root_endpoint" {
  description = "URL endpoint of API Gateway"
  value       = "https://${local.hostname}.${data.aws_route53_zone.this.name}"
}

output "test_path_endpoint" {
  description = "URL endpoint of API Gateway with test path"
  value       = "https://${local.hostname}.${data.aws_route53_zone.this.name}/test"
}

output "api_key_value" {
  description = "Generated API Key to use for requests"
  sensitive   = true
  value       = module.this.api_key_value
}