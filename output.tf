output "platform_name" {
  value       = "${var.platform_name}"
  description = "This platform name"
}

output "master_public_url" {
  value       = "${module.openshift.master_public_url}"
  description = "OpenShift master URL"
}

output "bastion_ssh_spec" {
  value       = "${module.infra.bastion_ssh_user}@${module.infra.bastion_endpoint}"
  description = "Bastion SSH info for login. 'ssh `terraform output bastion_ssh`'"
}

output "platform_private_key" {
  sensitive   = true
  value       = "${module.infra.platform_private_key}"
  description = "private key for instances"
}
