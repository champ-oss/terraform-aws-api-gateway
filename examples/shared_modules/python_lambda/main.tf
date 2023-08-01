data "archive_file" "this" {
  type        = "zip"
  source_file = "${path.module}/app.py"
  output_path = "package.zip"
}

resource "random_string" "this" {
  length  = 5
  special = false
  upper   = false
  lower   = true
  numeric = true
}

module "lambda" {
  source                            = "github.com/champ-oss/terraform-aws-lambda.git?ref=remove-api-gateway-deployment"
  git                               = "terraform-aws-api-gateway"
  name                              = random_string.this.result
  filename                          = data.archive_file.this.output_path
  source_code_hash                  = data.archive_file.this.output_base64sha256
  handler                           = "app.handler"
  runtime                           = "python3.9"
  reserved_concurrent_executions    = 1
  enable_api_gateway_v1             = true
  api_gateway_v1_rest_api_id        = var.api_gateway_v1_rest_api_id
  api_gateway_v1_parent_resource_id = var.api_gateway_v1_parent_resource_id
  api_gateway_v1_path_part          = var.api_gateway_v1_path_part
  api_gateway_v1_http_method        = var.api_gateway_v1_http_method
}
