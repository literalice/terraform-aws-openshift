output "master_url" {
  value = "${module.openshift_platform.master_url}"
  description = "OpenShift master(console) domain name"
}

output "bastion_public_dns" {
  value = "${module.openshift_platform.bastion_public_dns}"
  description = "Bastion domain name"
}

output "public_dns_nameservers" {
  value = "${module.openshift_platform.public_dns_nameservers}"
  description = "List of nameservers for delegation. Please set the nameservers in the parent hosted zone."
}

output "platform_private_key" {
  value = "${module.openshift_platform.platform_private_key}"
  sensitive = true
  description = "tmp private key for ssh to bastion"
}
