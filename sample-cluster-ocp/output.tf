output "bastion_public_dns" {
  value = "${module.openshift_domain.bastion_public_dns}"
}