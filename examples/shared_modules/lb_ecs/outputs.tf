output "lb_public_listener_arn" {
  value = module.core.lb_public_listener_arn
}

output "lb_private_listener_arn" {
  value = module.core.lb_private_listener_arn
}

output "ecs_app_security_group" {
  value = module.core.ecs_app_security_group
}

output "private_subnet_ids" {
  value = data.aws_subnets.private.ids
}

output "dns_name" {
  value = "${local.hostname}.${data.aws_route53_zone.this.name}"
}