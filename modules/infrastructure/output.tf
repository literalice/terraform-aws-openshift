output "bastion_instance_id" {
  value = "${data.aws_instances.bastion.ids[0]}"
}

output "bastion_ssh_user" {
  value = "${local.bastion_ssh_user}"
}

output "bastion_ssh" {
  value = "${local.bastion_ssh_user}@${data.aws_instances.bastion.ids[0]}"
}

output "bastion_endpoint" {
  value = "${data.aws_instances.bastion.public_ips[0]}"
}

output "platform_private_key" {
  sensitive = true
  value     = "${data.tls_public_key.platform.private_key_pem}"
}

output "master_endpoints" {
  value = ["${data.aws_instance.master.public_ip}"]
}

output "master_url" {
  value = "https://${local.platform_domain}:8443"
}

output "platform_domain" {
  value = "${local.platform_domain}"
}
