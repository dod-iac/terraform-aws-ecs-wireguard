
output "ecs_cluster_name" {
  value = module.ecs_cluster.ecs_cluster_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "efs_fs" {
  value = aws_efs_file_system.fs
}

output "efs_ap_id_config" {
  value = aws_efs_access_point.config.id
}

output "elb_dns_name" {
  value = aws_lb.main.dns_name
}
