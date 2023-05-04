output "account" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.this.account_id
}

output "aws_region" {
  description = "AWS Region"
  value       = data.aws_region.this.name
}

output "api_endpoint" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#api_endpoint"
  value       = aws_apigatewayv2_api.this[0].api_endpoint
}

output "arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#arn"
  value       = aws_apigatewayv2_api.this[0].arn
}

output "execution_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#execution_arn"
  value       = aws_apigatewayv2_api.this[0].execution_arn
}

output "id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#id"
  value       = aws_apigatewayv2_api.this[0].id
}

output "private_subnet_ids" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group#subnet_ids"
  value       = var.private_subnet_ids
}
