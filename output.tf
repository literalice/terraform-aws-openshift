output "bastion_ssh_spec" {
  value       = "${module.infra.bastion_ssh_user}@${module.infra.bastion_endpoint}"
  description = "Bastion SSH info for login. 'ssh `terraform output bastion_ssh`'"
}

output "platform_private_key" {
  sensitive   = true
  value       = "${module.infra.platform_private_key}"
  description = "private key for instances"
}
