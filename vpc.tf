
resource "aws_eip" "nat" {
  count = 3

  vpc = true

  tags = merge(var.tags, {
    Name = format("nat-%d-%s", count.index + 1, var.name)
  })
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.1"

  name = format("app-vpc-%s", var.name)
  cidr = "10.0.0.0/16"

  azs             = formatlist(format("%s%%s", data.aws_region.current.name), ["a", "b", "c"])
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  # One NAT Gateway per subnet (default behavior)
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
  reuse_nat_ips          = true
  external_nat_ip_ids    = aws_eip.nat.*.id

  # DNS Support
  enable_dns_hostnames = true
  enable_dns_support   = true

  # DHCP
  enable_dhcp_options = true

  # Tags
  tags = var.tags
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 3.1"

  vpc_id = module.vpc.vpc_id
  security_group_ids = [
    module.vpc.default_security_group_id,
    aws_security_group.endpoints.id,
  ]

  endpoints = {
    ecs = {
      service             = "ecs"
      private_dns_enabled = true
      subnet_ids          = module.vpc.public_subnets
    },
    ecs_telemetry = {
      service             = "ecs-telemetry"
      private_dns_enabled = true
      subnet_ids          = module.vpc.public_subnets
    },
    ec2 = {
      service             = "ec2"
      private_dns_enabled = true
      subnet_ids          = module.vpc.public_subnets
    },
    ec2messages = {
      service             = "ec2messages"
      private_dns_enabled = true
      subnet_ids          = module.vpc.public_subnets
    },
    kms = {
      service             = "kms"
      private_dns_enabled = true
      subnet_ids          = module.vpc.public_subnets
    },
  }

  tags = var.tags
}

resource "aws_security_group" "endpoints" {
  name_prefix = "app-security-group-endpoints"
  description = "Allows HTTPS for endpoints"
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol         = "TCP"
    from_port        = local.PORT_HTTPS
    to_port          = local.PORT_HTTPS
    cidr_blocks      = [local.CIDR_IPV4_INTERNET]
    ipv6_cidr_blocks = [local.CIDR_IPV6_INTERNET]
    description      = "HTTPS Access"
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = [local.CIDR_IPV4_INTERNET]
    ipv6_cidr_blocks = [local.CIDR_IPV6_INTERNET]
  }

  lifecycle {
    create_before_destroy = true
  }
}
