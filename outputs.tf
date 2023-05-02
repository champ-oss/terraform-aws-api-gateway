output "api_endpoint" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#api_endpoint"
  value       = aws_apigatewayv2_api.this.api_endpoint
}

output "arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#arn"
  value       = aws_apigatewayv2_api.this.arn
}

output "execution_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#execution_arn"
  value       = aws_apigatewayv2_api.this.execution_arn
}

output "id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#id"
  value       = aws_apigatewayv2_api.this.id
}

output "private_subnet_ids" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group#subnet_ids"
  value       = var.private_subnet_ids
}

output "vpc_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#vpc_id"
  value       = var.vpc_id
}