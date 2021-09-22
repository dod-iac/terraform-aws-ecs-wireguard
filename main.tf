/**
 * # ECS Wireguard
 *
 * ## Description
 *
 * Install a Wireguard service on ECS backed by EC2 autoscaling
 *
 * ## Usage
 *
 * ```hcl
 * module "wireguard" {
 *   source = "../../modules/wireguard"
 *
 *   server_url      = "wireguard.example.com"
 *   wireguard_peers = 2
 * }
 * ```
 *
 * ## Interacting with the server
 *
 * <https://aws.amazon.com/blogs/containers/new-using-amazon-ecs-exec-access-your-containers-fargate-ec2/>
 *
 * ## Testing
 *
 * No tests currently exist for this module.
 *
 * ## Terraform Version
 *
 * Terraform 1.0. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.
 *
 * Terraform prior to 1.0 are not supported.
 *
 * ## License
 *
 * This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.
 *
 * ## Developer Setup
 *
 * This template is configured to use aws-vault, direnv, pre-commit, terraform-docs, and tfenv.  If using Homebrew on macOS, you can install the dependencies using the following code.
 *
 * ```shell
 * brew install aws-vault direnv pre-commit terraform-docs tfenv
 * pre-commit install --install-hooks
 * ```
 *
 * If using `direnv`, add a `.envrc.local` that sets the default AWS region, e.g., `export AWS_DEFAULT_REGION=us-west-2`.
 *
 * If using `tfenv`, then add a `.terraform-version` to the project root dir, with the version you would like to use.
 *
 *
 */

data "aws_region" "current" {}
