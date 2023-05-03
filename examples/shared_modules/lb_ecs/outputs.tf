output "lb_public_listener_arn" {
  description = "core module public lb listener arn"
  value       = module.core.lb_public_listener_arn
}

output "lb_private_listener_arn" {
  description = "core module private lb listener arn"
  value       = module.core.lb_private_listener_arn
}

output "ecs_app_security_group" {
  description = "core module security group for ecs"
  value       = module.core.ecs_app_security_group
}

output "private_subnet_ids" {
  description = "list of private vpc subnets"
  value       = data.aws_subnets.private.ids
}

output "dns_name" {
  description = "DNS name used for ecs application"
  value       = "${local.hostname}.${data.aws_route53_zone.this.name}"
}