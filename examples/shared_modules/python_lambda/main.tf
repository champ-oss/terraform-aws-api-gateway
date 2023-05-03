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
  source                         = "github.com/champ-oss/terraform-aws-lambda.git?ref=v1.0.116-111a99f"
  git                            = "terraform-aws-api-gateway"
  name                           = random_string.this.result
  filename                       = data.archive_file.this.output_path
  source_code_hash               = data.archive_file.this.output_base64sha256
  handler                        = "app.handler"
  runtime                        = "python3.9"
  reserved_concurrent_executions = 1
}
