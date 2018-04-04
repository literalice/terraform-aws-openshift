output "master_url" {
  value       = "https://master.${var.platform_default_subdomain}:8443"
  description = "OpenShift master(console) domain name"
}

output "bastion_ssh" {
  value       = "${module.infrastructure.bastion_ssh_user}@${module.infrastructure.bastion_public_dns}"
  description = "Bastion SSH info for login. 'ssh `terraform output bastion_ssh`'"
}

output "bastion_public_dns" {
  value       = "${module.domain.bastion_public_dns}"
  description = "Bastion domain name"
}

output "public_dns_nameservers" {
  value       = "${module.domain.public_dns_nameservers}"
  description = "List of nameservers for delegation. Please set the nameservers in the parent hosted zone."
}

output "platform_private_key" {
  sensitive   = true
  value       = "${module.infrastructure.platform_private_key}"
  description = "private key for instances"
}
