data "archive_file" "this" {
  type        = "zip"
  source_dir  = path.module
  output_path = "package.zip"
}

module "lambda" {
  source                         = "github.com/champ-oss/terraform-aws-lambda.git?ref=v1.0.116-111a99f"
  git                            = local.git
  name                           = "lambda"
  filename                       = data.archive_file.this.output_path
  source_code_hash               = data.archive_file.this.output_base64sha256
  handler                        = "app.handler"
  runtime                        = "python3.9"
  reserved_concurrent_executions = 1
}