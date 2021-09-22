
resource "aws_security_group" "nfs" {
  name_prefix = "app-security-group-nfs"
  description = "Allows NFS traffic for EFS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol         = "TCP"
    from_port        = local.PORT_NFS
    to_port          = local.PORT_NFS
    cidr_blocks      = [local.CIDR_IPV4_INTERNET]
    ipv6_cidr_blocks = [local.CIDR_IPV6_INTERNET]
    description      = "NFS Access"
  }

  egress {
    protocol         = "TCP"
    from_port        = local.PORT_NFS
    to_port          = local.PORT_NFS
    cidr_blocks      = [local.CIDR_IPV4_INTERNET]
    ipv6_cidr_blocks = [local.CIDR_IPV6_INTERNET]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "wireguard" {
  name_prefix = format("app-security-group-%s", var.name)
  description = "Allows HTTP/HTTPS and WireGuard VPN traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol         = "UDP"
    from_port        = local.PORT_WIREGUARD
    to_port          = local.PORT_WIREGUARD
    cidr_blocks      = [local.CIDR_IPV4_INTERNET]
    ipv6_cidr_blocks = [local.CIDR_IPV6_INTERNET]
    description      = "Wireguard Access"
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

resource "aws_security_group" "ssh" {
  count = length(var.ssh_public_key) > 0 ? 1 : 0

  name_prefix = "app-security-group-ssh"
  description = "Allows SSH traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol         = "TCP"
    from_port        = local.PORT_SSH
    to_port          = local.PORT_SSH
    cidr_blocks      = [local.CIDR_IPV4_INTERNET]
    ipv6_cidr_blocks = [local.CIDR_IPV6_INTERNET]
    description      = "SSH Access"
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
