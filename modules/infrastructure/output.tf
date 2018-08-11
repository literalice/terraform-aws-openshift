output "bastion_instance_id" {
  value = "${data.aws_instance.bastion.id}"
}

output "bastion_ssh_user" {
  value = "${local.bastion_ssh_user}"
}

output "bastion_public_dns" {
  value = "${data.aws_instance.bastion.public_dns}"
}

output "platform_private_key" {
  sensitive = true
  value     = "${data.tls_public_key.platform.private_key_pem}"
}

output "master_endpoints" {
  value = ["${data.aws_instance.master.public_ip}"]
}
