
locals {
  cloudwatch_logs_group_name = format("/aws/ecs/%s", var.name)
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = local.cloudwatch_logs_group_name
  retention_in_days = var.cloudwatch_log_retention_in_days
  kms_key_id        = module.cloudwatch_kms_key.aws_kms_key_arn

  tags = var.tags
}

module "cloudwatch_kms_key" {
  source  = "dod-iac/cloudwatch-kms-key/aws"
  version = "~> 1.0.0"

  name = format("alias/%s-cloudwatch-kms", var.name)
  tags = var.tags
}
