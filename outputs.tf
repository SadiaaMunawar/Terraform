# Root module outputs

output "web_server_id" {
  description = "ID of the web server EC2 instance"
  value       = try(module.web_server.instance_id, "Not deployed yet")
}

output "web_server_ip" {
  description = "Public IP of the web server (for Nginx access)"
  value       = try(module.web_server.public_ip, "Not deployed yet")
}

output "db_server_id" {
  description = "ID of the DB server EC2 instance"
  value       = try(module.db_server.instance_id, "Not deployed yet")
}

output "db_server_ip" {
  description = "Public IP of the DB server"
  value       = try(module.db_server.public_ip, "Not deployed yet")
}

output "current_workspace" {
  description = "Current Terraform workspace"
  value       = terraform.workspace
}
