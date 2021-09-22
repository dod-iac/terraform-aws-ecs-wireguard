
# Network Load Balancer

resource "aws_eip" "nlb" {
  count = length(module.vpc.public_subnets)

  vpc = true

  tags = merge(var.tags, {
    Name = format("nlb-%d-%s", count.index + 1, var.name)
  })
}

resource "aws_lb" "main" {
  name                             = format("app-elb-%s", var.name)
  internal                         = false
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true
  enable_http2                     = true

  # Access logs don't work for NLB

  dynamic "subnet_mapping" {
    for_each = module.vpc.public_subnets
    content {
      subnet_id     = subnet_mapping.value
      allocation_id = aws_eip.nlb[subnet_mapping.key].id
    }

  }

  tags = var.tags
}

# UDP - wireguard

resource "aws_lb_target_group" "main_wireguard" {
  name        = format("app-tg-wg-%s", var.name)
  port        = local.PORT_WIREGUARD
  protocol    = "UDP"
  target_type = "instance"
  vpc_id      = module.vpc.vpc_id

  tags = var.tags
}

resource "aws_lb_listener" "main_wireguard" {
  load_balancer_arn = aws_lb.main.arn
  port              = local.PORT_WIREGUARD
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main_wireguard.arn
  }

  tags = var.tags
  depends_on = [
    aws_lb_target_group.main_wireguard,
  ]
}

