output "bastion_instance_id" {
  value = "${aws_instance.bastion.id}"
}

output "platform_public_lb_arn" {
  value = "${aws_lb.platform_public.arn}"
}

output "master_public_lb_arn" {
  value = "${aws_lb.master_public.arn}"
}

output "master_lb_arn" {
  value = "${aws_elb.master.arn}"
}

output "master_lb_name" {
  value = "${aws_elb.master.name}"
}

output "master_private_dns_name" {
  value = "master.${var.platform_name}.internal"
}

output "platform_private_key" {
  sensitive = true
  value = "${data.tls_public_key.platform.private_key_pem}"
}
