output "arn" {
  description = "Lambda ARN"
  value       = module.lambda.arn
}

output "api_gateway_v1_resource_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource#id"
  value       = module.lambda.api_gateway_v1_resource_id
}

output "api_gateway_v1_method_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method"
  value       = module.lambda.api_gateway_v1_method_id
}

output "api_gateway_v1_integration_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration"
  value       = module.lambda.api_gateway_v1_integration_id
}