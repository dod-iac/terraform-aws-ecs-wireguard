
module "ecs_task_execution_role" {
  source  = "dod-iac/ecs-task-execution-role/aws"
  version = "~> 1.0"

  cloudwatch_log_group_names = [aws_cloudwatch_log_group.logs.name]
  name                       = format("ecs-task-execution-role-%s", var.name)
  tags                       = var.tags
}

module "ecs_task_role" {
  source  = "dod-iac/ecs-task-role/aws"
  version = "~> 1.0"

  name = format("ecs-task-role-%s", var.name)
  tags = var.tags
}

data "aws_iam_policy_document" "efs" {
  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientRootAccess",
      "elasticfilesystem:ClientWrite",
    ]
    resources = [
      aws_efs_file_system.fs.arn,
    ]
    # condition {
    #   test     = "StringEquals"
    #   variable = "elasticfilesystem:AccessPointArn"
    #   values = [
    #     aws_efs_access_point.config.arn,
    #   ]
    # }
  }
}

resource "aws_iam_policy" "efs_policy" {
  name        = format("ecs-efs-policy-%s", var.name)
  description = "A policy to enable EFS access from ECS"
  policy      = data.aws_iam_policy_document.efs.json
}

resource "aws_iam_role_policy_attachment" "task" {
  role       = module.ecs_task_role.name
  policy_arn = aws_iam_policy.efs_policy.arn
}


data "aws_iam_policy_document" "exec_command" {
  statement {
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups",
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
    ]
    resources = [
      aws_cloudwatch_log_group.logs.arn,
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
    ]
    resources = [module.ecs_cluster.aws_kms_key_arn_exec_command]
  }
}

resource "aws_iam_policy" "exec_command_policy" {
  name        = format("ecs-exec-command-policy-%s", var.name)
  description = "A policy to enable Exec Command access to ECS"
  policy      = data.aws_iam_policy_document.exec_command.json
}

resource "aws_iam_role_policy_attachment" "exec_command_task" {
  role       = module.ecs_task_role.name
  policy_arn = aws_iam_policy.exec_command_policy.arn
}
