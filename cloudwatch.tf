resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/apigateway/${var.git}-${random_string.this.result}"
  retention_in_days = var.retention_in_days
  tags              = merge(local.tags, var.tags)
}