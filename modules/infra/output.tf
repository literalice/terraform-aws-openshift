output "bastion_ssh_user" {
  value = "${local.bastion_ssh_user}"
}

output "bastion_endpoint" {
  value = "${aws_eip.bastion.public_ip}"
}

output "platform_private_key" {
  sensitive = true
  value     = "${data.tls_public_key.platform.private_key_pem}"
}
