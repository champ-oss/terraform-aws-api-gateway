output "account" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.this.account_id
}

output "aws_region" {
  description = "AWS Region"
  value       = data.aws_region.this.name
}

output "api_key_value" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_api_key#value"
  sensitive   = true
  value       = var.enable_api_key ? aws_api_gateway_api_key.this[0].value : null
}

output "id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api#id"
  value       = aws_api_gateway_rest_api.this.id
}

output "root_resource_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api#root_resource_id"
  value       = aws_api_gateway_rest_api.this.root_resource_id
}

output "private_subnet_ids" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group#subnet_ids"
  value       = var.private_subnet_ids
}

output "rest_api_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api#id"
  value       = aws_api_gateway_rest_api.this.id
}

output "method_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method"
  value       = aws_api_gateway_method.this.id
}

output "integration_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration"
  value       = aws_api_gateway_integration.this.id
}

output "stage_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage#id"
  value       = aws_api_gateway_stage.this.id
}

output "domain_name_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name#id"
  value       = var.enable_domain_name ? aws_api_gateway_domain_name.this[0].id : null
}

output "base_path_mapping_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_base_path_mapping"
  value       = var.enable_domain_name ? aws_api_gateway_base_path_mapping.this[0].id : null
}

output "rest_api_policy_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api_policy#id"
  value       = aws_api_gateway_rest_api_policy.this.id
}

output "usage_plan_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_usage_plan#id"
  value       = var.enable_api_key ? aws_api_gateway_usage_plan.this[0].id : null
}