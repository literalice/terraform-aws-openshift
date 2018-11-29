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

output "public_lb_arn" {
  value = "${aws_lb.public.arn}"
}

output "master_domain" {
  value = "${aws_route53_record.master.name}"
}

output "platform_public_ip_set" {
  value = "${data.dns_a_record_set.platform_public_ip_set.addrs}"
}
