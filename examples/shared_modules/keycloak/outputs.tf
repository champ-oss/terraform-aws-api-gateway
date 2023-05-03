output "keycloak_endpoint" {
  depends_on  = [time_sleep.this]
  description = "keycloak endpoint url"
  value       = module.keycloak.keycloak_endpoint
}

output "keycloak_admin_password" {
  depends_on  = [time_sleep.this]
  description = "keycloak admin password"
  value       = module.keycloak.keycloak_admin_password
  sensitive   = true
}