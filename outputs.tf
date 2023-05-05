output "account" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.this.account_id
}

output "aws_region" {
  description = "AWS Region"
  value       = data.aws_region.this.name
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
