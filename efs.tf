
module "efs_key" {
  source  = "dod-iac/efs-kms-key/aws"
  version = "~> 1.0"

  name = format("alias/efs-%s", var.name)
}

resource "aws_efs_file_system" "fs" {
  encrypted  = true
  kms_key_id = module.efs_key.aws_kms_key_arn

  tags = merge(var.tags, { Name = format("%s-fs", var.name) })
}

resource "aws_efs_access_point" "config" {
  file_system_id = aws_efs_file_system.fs.id
  posix_user {
    uid            = local.POSIX_USER
    gid            = local.POSIX_GROUP
    secondary_gids = []
  }
  root_directory {
    path = "/config"
    creation_info {
      owner_uid   = local.POSIX_USER
      owner_gid   = local.POSIX_GROUP
      permissions = "0777"
    }
  }

  tags = merge(var.tags, { Name = format("%s-config", var.name) })
}

data "aws_iam_policy_document" "fs" {
  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = [aws_efs_file_system.fs.arn]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_efs_file_system_policy" "policy" {
  file_system_id = aws_efs_file_system.fs.id
  policy         = data.aws_iam_policy_document.fs.json
}

resource "aws_efs_mount_target" "fs" {
  count = length(module.vpc.public_subnets)

  file_system_id  = aws_efs_file_system.fs.id
  security_groups = [aws_security_group.nfs.id]
  subnet_id       = module.vpc.public_subnets[count.index]
}

resource "aws_efs_backup_policy" "policy" {
  file_system_id = aws_efs_file_system.fs.id

  backup_policy {
    status = "ENABLED"
  }
}
