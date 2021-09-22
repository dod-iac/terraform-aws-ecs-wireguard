
module "ecs_instance_role" {
  source  = "dod-iac/ec2-instance-role/aws"
  version = "~> 1.0"

  allow_ecs = true
  name      = format("app-ecs-instance-role-%s", var.name)

  tags = var.tags
}

resource "aws_iam_instance_profile" "ecs_instance_role" {
  name = module.ecs_instance_role.name
  role = module.ecs_instance_role.name
}

// https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-ami-versions.html
// aws ssm get-parameters --names /aws/service/ecs/optimized-ami/amazon-linux-2/recommended | jq -r .Parameters[0].Value | jq -r .image_id
data "aws_ami" "vpn" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_key_pair" "main" {
  count      = length(var.ssh_public_key) > 0 ? 1 : 0
  key_name   = var.key_name
  public_key = var.ssh_public_key
  tags       = var.tags
}

module "ecs_cluster" {
  source  = "dod-iac/ecs-cluster/aws"
  version = "~> 1.3"

  desired_capacity = 1
  min_size         = 1
  max_size         = 1

  iam_instance_profile          = aws_iam_instance_profile.ecs_instance_role.arn
  instance_type                 = var.ec2_instance_type
  name                          = var.name
  root_block_device_volume_size = pow(2, 5) # 32GB is a minimum for the image
  subnet_ids                    = module.vpc.public_subnets
  target_capacity               = 70
  vpc_id                        = module.vpc.vpc_id
  image_id                      = data.aws_ami.vpn.image_id
  user_data = templatefile(format("%s/userdata.tmpl", path.module), {
    ecs_cluster = var.name,
    region      = data.aws_region.current.name
    tags        = merge(var.tags, { Name = var.name })
  })
  security_groups = concat([
    aws_security_group.nfs.id,
    aws_security_group.wireguard.id,
  ], aws_security_group.ssh[*].id)

  # Enable for SSH only
  associate_public_ip_address = length(var.ssh_public_key) > 0 ? true : false
  key_name                    = length(var.ssh_public_key) > 0 ? aws_key_pair.main[0].key_name : ""

  tags = var.tags
}
