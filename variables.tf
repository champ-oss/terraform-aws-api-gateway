variable "api_key_value" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_api_key#value"
  type        = string
  default     = null
}

variable "domain_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name#domain_name"
  type        = string
  default     = null
}

variable "endpoint_type" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api#types"
  type        = string
  default     = "REGIONAL"
}

variable "logging_level" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings#logging_level"
  type        = string
  default     = "INFO"
}

variable "certificate_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_domain_name#certificate_arn"
  type        = string
  default     = null
}

variable "cidr_blocks" {
  description = "IP CIDR ranges to whitelist (maximum of around 400 IP ranges)"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}

variable "description" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#description"
  type        = string
  default     = null
}

variable "disable_execute_api_endpoint" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#disable_execute_api_endpoint"
  type        = bool
  default     = false
}

variable "enable_create_certificate" {
  description = "Create an ACM certificate"
  type        = bool
  default     = true
}

variable "enable_domain_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name"
  type        = bool
  default     = true
}

variable "enable_api_key" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_api_key"
  type        = bool
  default     = false
}

variable "enable_lambda_integration" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration#integration_uri"
  type        = bool
  default     = false
}

variable "git" {
  description = "Name of the Git repo"
  type        = string
}

variable "lambda_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#arn"
  type        = string
  default     = null
}

variable "private_subnet_ids" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group#subnet_ids"
  type        = list(string)
  default     = []
}

variable "retention_in_days" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group#retention_in_days"
  type        = number
  default     = 365
}

variable "tags" {
  description = "Map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "zone_id" {
  description = "https://www.terraform.io/docs/providers/aws/r/route53_record.html#zone_id"
  type        = string
  default     = null
}