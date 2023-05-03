resource "aws_apigatewayv2_vpc_link" "this" {
  count              = var.enable_lb_integration ? 1 : 0
  name               = "${var.git}-${random_string.this.result}"
  security_group_ids = var.security_group_ids
  subnet_ids         = var.private_subnet_ids
  tags               = merge(local.tags, var.tags)
}