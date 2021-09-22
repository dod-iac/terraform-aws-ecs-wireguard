<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# ECS Wireguard

## Description

Install a Wireguard service on ECS backed by EC2 autoscaling

## Usage

```hcl
module "wireguard" {
  source = "../../modules/wireguard"

  server_url      = "wireguard.example.com"
  wireguard_peers = 2
}
```

## Interacting with the server

<https://aws.amazon.com/blogs/containers/new-using-amazon-ecs-exec-access-your-containers-fargate-ec2/>

## Testing

No tests currently exist for this module.

## Terraform Version

Terraform 1.0. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.

Terraform prior to 1.0 are not supported.

## License

This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.

## Developer Setup

This template is configured to use aws-vault, direnv, pre-commit, terraform-docs, and tfenv.  If using Homebrew on macOS, you can install the dependencies using the following code.

```shell
brew install aws-vault direnv pre-commit terraform-docs tfenv
pre-commit install --install-hooks
```

If using `direnv`, add a `.envrc.local` that sets the default AWS region, e.g., `export AWS_DEFAULT_REGION=us-west-2`.

If using `tfenv`, then add a `.terraform-version` to the project root dir, with the version you would like to use.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudwatch_kms_key"></a> [cloudwatch\_kms\_key](#module\_cloudwatch\_kms\_key) | dod-iac/cloudwatch-kms-key/aws | ~> 1.0.0 |
| <a name="module_ecs_cluster"></a> [ecs\_cluster](#module\_ecs\_cluster) | dod-iac/ecs-cluster/aws | ~> 1.3 |
| <a name="module_ecs_instance_role"></a> [ecs\_instance\_role](#module\_ecs\_instance\_role) | dod-iac/ec2-instance-role/aws | ~> 1.0 |
| <a name="module_ecs_task_execution_role"></a> [ecs\_task\_execution\_role](#module\_ecs\_task\_execution\_role) | dod-iac/ecs-task-execution-role/aws | ~> 1.0 |
| <a name="module_ecs_task_role"></a> [ecs\_task\_role](#module\_ecs\_task\_role) | dod-iac/ecs-task-role/aws | ~> 1.0 |
| <a name="module_efs_key"></a> [efs\_key](#module\_efs\_key) | dod-iac/efs-kms-key/aws | ~> 1.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 3.1 |
| <a name="module_vpc_endpoints"></a> [vpc\_endpoints](#module\_vpc\_endpoints) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | ~> 3.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_service.wireguard](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.wireguard](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_efs_access_point.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point) | resource |
| [aws_efs_backup_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_backup_policy) | resource |
| [aws_efs_file_system.fs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_file_system_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system_policy) | resource |
| [aws_efs_mount_target.fs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip.nlb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.ecs_instance_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.efs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.exec_command_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.exec_command_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_key_pair.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_lb.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.main_wireguard](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.main_wireguard](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.nfs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.wireguard](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy_document.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.exec_command](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.fs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_retention_in_days"></a> [cloudwatch\_log\_retention\_in\_days](#input\_cloudwatch\_log\_retention\_in\_days) | The cloudwatch log description in days | `number` | `90` | no |
| <a name="input_ec2_instance_type"></a> [ec2\_instance\_type](#input\_ec2\_instance\_type) | The EC2 instance type to launch for the cluster | `string` | `"t2.small"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The AWS Key Pair Key Name | `string` | `"wireguard"` | no |
| <a name="input_name"></a> [name](#input\_name) | A unique name for the module | `string` | `"wireguard"` | no |
| <a name="input_server_tz"></a> [server\_tz](#input\_server\_tz) | The time zone for the server | `string` | `"America/Los_Angeles"` | no |
| <a name="input_server_url"></a> [server\_url](#input\_server\_url) | The FQDN serving wireguard (ex: www.example.com) | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | The public key to use for an AWS key pair. This will enable SSH access to the ECS cluster EC2 instance. Leaving this blank will disable access. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | tags | `map(string)` | `{}` | no |
| <a name="input_wireguard_peers"></a> [wireguard\_peers](#input\_wireguard\_peers) | The number of wireguard peers to configure. When using wireguard-ui set to 0 or leave as default. | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | n/a |
| <a name="output_efs_ap_id_config"></a> [efs\_ap\_id\_config](#output\_efs\_ap\_id\_config) | n/a |
| <a name="output_efs_fs"></a> [efs\_fs](#output\_efs\_fs) | n/a |
| <a name="output_elb_dns_name"></a> [elb\_dns\_name](#output\_elb\_dns\_name) | n/a |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
