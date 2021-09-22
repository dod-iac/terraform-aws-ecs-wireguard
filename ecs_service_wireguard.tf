resource "aws_ecs_task_definition" "wireguard" {
  family = var.name
  container_definitions = jsonencode([
    {
      name      = var.name
      image     = "linuxserver/wireguard:v1.0.20210424-ls36"
      cpu       = 1
      memory    = 512
      essential = true
      environment = [
        {
          Name  = "PUID"
          Value = tostring(local.POSIX_USER)
        },
        {
          Name  = "PGID"
          Value = tostring(local.POSIX_GROUP)
        },
        {
          Name  = "TZ"
          Value = var.server_tz
        },
        {
          Name  = "SERVER_URL"
          Value = var.server_url
        },
        {
          Name  = "SERVER_PORT"
          Value = tostring(local.PORT_WIREGUARD)
        },
        {
          Name  = "PEERS"
          Value = tostring(var.wireguard_peers)
        },
        {
          Name  = "PEERDNS"
          Value = "auto"
        },
        {
          Name  = "INTERNAL_SUBNET"
          Value = "10.13.13.0"
        },
        {
          Name = "ALLOWEDIPS"
          Value = join(",", [
            local.CIDR_IPV4_INTERNET,
            local.CIDR_IPV6_INTERNET,
          ])
        },
      ]
      mountPoints = [
        {
          containerPath = "/config"
          sourceVolume  = "config"
        },
        {
          containerPath = "/lib/modules"
          sourceVolume  = "lib-modules"
        },
        {
          containerPath = "/usr/src"
          sourceVolume  = "usr-src"
          readOnly      = true
        },
      ]
      volumesFrom = []
      linuxParameters = {
        capabilities = {
          add = ["NET_ADMIN", "SYS_MODULE"]
        }
        initProcessEnabled = true
      }
      systemControls = [
        # net.ipv4.ip_forward=1
        # net.ipv4.conf.all.rp_filter=2
        {
          namespace = "net.ipv4.conf.all.src_valid_mark"
          value     = "1"
        }
      ]
      portmappings = [
        {
          protocol      = "udp"
          containerport = local.PORT_WIREGUARD
          hostport      = local.PORT_WIREGUARD
        },
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = local.cloudwatch_logs_group_name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = var.name
        }
      }
    },
  ])

  execution_role_arn       = module.ecs_task_execution_role.arn
  task_role_arn            = module.ecs_task_role.arn
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]

  volume {
    name = "config"

    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.fs.id
      transit_encryption = "ENABLED"

      authorization_config {
        access_point_id = aws_efs_access_point.config.id
        iam             = "ENABLED"
      }
    }
  }

  volume {
    name      = "lib-modules"
    host_path = "/lib/modules"
  }

  volume {
    name      = "usr-src"
    host_path = "/usr/src"
  }

  tags = var.tags
}

resource "aws_ecs_service" "wireguard" {
  cluster         = module.ecs_cluster.ecs_cluster_name
  desired_count   = 1
  launch_type     = "EC2"
  name            = var.name
  task_definition = aws_ecs_task_definition.wireguard.arn

  enable_execute_command = true

  load_balancer {
    container_name   = var.name
    container_port   = local.PORT_WIREGUARD
    target_group_arn = aws_lb_target_group.main_wireguard.arn
  }

  depends_on = [
    aws_cloudwatch_log_group.logs,
  ]

  tags = var.tags
}
