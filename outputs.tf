output "account" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.this.account_id
}

output "aws_region" {
  description = "AWS Region"
  value       = data.aws_region.this.name
}

output "api_gateway_v1_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api#id"
  value       = var.enable_api_gateway_v1 ? aws_api_gateway_rest_api.this[0].id : null
}

output "api_gateway_v1_root_resource_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api#root_resource_id"
  value       = var.enable_api_gateway_v1 ? aws_api_gateway_rest_api.this[0].root_resource_id : null
}

output "api_gateway_v2_api_endpoint" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#api_endpoint"
  value       = var.enable_api_gateway_v2 ? aws_apigatewayv2_api.this[0].api_endpoint : null
}

output "api_gateway_v2_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#arn"
  value       = var.enable_api_gateway_v2 ? aws_apigatewayv2_api.this[0].arn : null
}

output "api_gateway_v2_execution_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#execution_arn"
  value       = var.enable_api_gateway_v2 ? aws_apigatewayv2_api.this[0].execution_arn : null
}

output "api_gateway_v2_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#id"
  value       = var.enable_api_gateway_v2 ? aws_apigatewayv2_api.this[0].id : null
}

output "private_subnet_ids" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group#subnet_ids"
  value       = var.private_subnet_ids
}

output "api_gateway_v1_api_key_value" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_api_key#value"
  value       = var.enable_api_gateway_v1 && var.enable_api_gateway_v1_api_key ? aws_api_gateway_api_key.this[0].value : null
}
