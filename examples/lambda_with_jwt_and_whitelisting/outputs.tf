output "api_gateway_endpoint1" {
  description = "URL endpoint of API Gateway"
  value       = "https://${local.hostname1}.${data.aws_route53_zone.this.name}"
}

output "api_gateway_endpoint2" {
  description = "URL endpoint of API Gateway"
  value       = "https://${local.hostname2}.${data.aws_route53_zone.this.name}"
}

output "keycloak_endpoint" {
  description = "keycloak endpoint url"
  value       = module.keycloak.keycloak_endpoint
}

output "keycloak_admin_password" {
  description = "keycloak admin pw"
  value       = module.keycloak.keycloak_admin_password
  sensitive   = true
}