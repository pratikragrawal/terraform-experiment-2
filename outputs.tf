output "web_public_ips" {
  description = "Public IP addresses of the web servers"
  value       = module.compute.web_public_ips
}

output "db_private_ip" {
  description = "Private IP address of the database server"
  value       = module.compute.db_private_ip
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.network.vpc_id
}