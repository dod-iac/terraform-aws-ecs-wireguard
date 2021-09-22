
locals {
  PORT_SSH       = 22
  PORT_HTTPS     = 443
  PORT_WIREGUARD = 51820
  PORT_NFS       = 2049

  CIDR_IPV4_INTERNET = "0.0.0.0/0"
  CIDR_IPV6_INTERNET = "::/0"

  POSIX_USER  = 0
  POSIX_GROUP = 0
}

variable "name" {
  type        = string
  default     = "wireguard"
  description = "A unique name for the module"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "tags"
}

variable "cloudwatch_log_retention_in_days" {
  type        = number
  default     = 90
  description = "The cloudwatch log description in days"
}

variable "ec2_instance_type" {
  type        = string
  default     = "t2.small"
  description = "The EC2 instance type to launch for the cluster"
}

variable "server_tz" {
  type        = string
  default     = "America/Los_Angeles"
  description = "The time zone for the server"
}

variable "server_url" {
  type        = string
  description = "The FQDN serving wireguard (ex: www.example.com)"
}

variable "ssh_public_key" {
  type        = string
  default     = ""
  description = "The public key to use for an AWS key pair. This will enable SSH access to the ECS cluster EC2 instance. Leaving this blank will disable access."
}

variable "wireguard_peers" {
  type        = number
  default     = 0
  description = "The number of wireguard peers to configure. When using wireguard-ui set to 0 or leave as default."
}

variable "key_name" {
  type        = string
  default     = "wireguard"
  description = "The AWS Key Pair Key Name"
}
