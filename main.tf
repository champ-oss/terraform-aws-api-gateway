data "aws_region" "this" {}
data "aws_caller_identity" "this" {}

locals {
  tags = {
    git     = var.git
    cost    = "shared"
    creator = "terraform"
  }
}

resource "random_string" "this" {
  length  = 5
  special = false
  upper   = false
  lower   = true
  numeric = true
}