output "bastion_public_dns" {
  value = "${module.openshift_domain.bastion_public_dns}"
  description = "Bastion domain name"
}

output "public_dns_nameservers" {
  value = "${module.openshift_domain.public_dns_nameservers}"
  description = "List of nameservers for delegation. Please set the nameservers in the parent hosted zone."
}

