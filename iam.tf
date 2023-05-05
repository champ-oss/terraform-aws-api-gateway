resource "aws_iam_role" "this" {
  count              = var.enable_api_gateway_v1 ? 1 : 0
  name_prefix        = "${var.git}-apigateway-${random_string.this.result}-"
  assume_role_policy = data.aws_iam_policy_document.assume_role[0].json
  tags               = merge(local.tags, var.tags)
}

resource "aws_iam_role_policy" "this" {
  count       = var.enable_api_gateway_v1 ? 1 : 0
  name_prefix = "${var.git}-apigateway-${random_string.this.result}-"
  role        = aws_iam_role.this[0].id
  policy      = data.aws_iam_policy_document.cloudwatch[0].json
}

data "aws_iam_policy_document" "assume_role" {
  count = var.enable_api_gateway_v1 ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudwatch" {
  count = var.enable_api_gateway_v1 ? 1 : 0
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
    ]

    resources = ["*"]
  }
}
