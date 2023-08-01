resource "aws_iam_role" "this" {
  name_prefix        = substr("${var.git}-apigateway-${random_string.this.result}-", 0, 36)
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = merge(local.tags, var.tags)
}

resource "aws_iam_role_policy" "this" {
  name_prefix = substr("${var.git}-apigateway-${random_string.this.result}-", 0, 36)
  role        = aws_iam_role.this.id
  policy      = data.aws_iam_policy_document.cloudwatch.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudwatch" {
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
