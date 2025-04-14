output "load_balancer_dns" {
  description = "Public ALB DNS"
  value       = module.lb.dns_name
}
