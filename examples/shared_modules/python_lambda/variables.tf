variable "api_gateway_v1_rest_api_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource#rest_api_id"
  type        = string
}

variable "api_gateway_v1_parent_resource_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource#parent_id"
  type        = string
  default     = null
}

variable "api_gateway_v1_path_part" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource#path_part"
  default     = null
  type        = string
}

variable "api_gateway_v1_http_method" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method#http_method"
  type        = string
}

variable "api_gateway_v1_resource_path" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource#path"
  type        = string
  default     = null
}

variable "api_gateway_v1_resource_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method#resource_id"
  type        = string
  default     = null
}