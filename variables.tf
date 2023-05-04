variable "certificate_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_domain_name#certificate_arn"
  type        = string
  default     = null
}

variable "cors_configuration_allow_credentials" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#allow_credentials"
  type        = bool
  default     = null
}

variable "cors_configuration_allow_headers" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#allow_headers"
  type        = list(string)
  default     = null
}

variable "cors_configuration_allow_methods" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#allow_methods"
  type        = list(string)
  default     = null
}

variable "cors_configuration_allow_origins" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#allow_origins"
  type        = list(string)
  default     = null
}

variable "cors_configuration_expose_headers" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#expose_headers"
  type        = list(string)
  default     = null
}

variable "cors_configuration_max_age" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#max_age"
  type        = number
  default     = null
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

variable "domain_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_domain_name#domain_name"
  type        = string
}

variable "enable_create_certificate" {
  description = "Create an ACM certificate"
  type        = bool
  default     = true
}

variable "enable_api_gateway_v1" {
  description = "Supports IP whitelisting"
  type        = bool
  default     = false
}

variable "enable_api_gateway_v2" {
  description = "Supports JWT authorization"
  type        = bool
  default     = false
}

variable "enable_lambda_integration" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration#integration_uri"
  type        = bool
  default     = false
}

variable "enable_lb_integration" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration#integration_uri"
  type        = bool
  default     = false
}

variable "git" {
  description = "Name of the Git repo"
  type        = string
}

variable "identity_sources" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_authorizer#identity_sources"
  type        = list(string)
  default     = ["$request.header.Authorization"]
}

variable "integration_method" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration#integration_method"
  type        = string
  default     = "POST"
}

variable "jwt_audience" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_authorizer#audience"
  type        = list(string)
  default     = ["account"]
}

variable "jwt_issuer" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_authorizer#issuer"
  type        = string
  default     = ""
}

variable "lambda_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function#arn"
  type        = string
  default     = null
}

variable "lb_listener_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration#integration_uri"
  type        = string
  default     = null
}

variable "lb_domain_name" {
  description = "Domain name the load balancer expects"
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

variable "security_group_ids" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_vpc_link#security_group_ids"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "zone_id" {
  description = "https://www.terraform.io/docs/providers/aws/r/route53_record.html#zone_id"
  type        = string
}