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
  value       = aws_api_gateway_rest_api.this[0].id
}

output "root_resource_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api#root_resource_id"
  value       = aws_api_gateway_rest_api.this[0].root_resource_id
}

output "private_subnet_ids" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group#subnet_ids"
  value       = var.private_subnet_ids
}

