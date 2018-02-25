output "bastion_public_dns" {
  value = "${aws_route53_record.bastion_public.name}"
}

output "public_dns_nameservers" {
  value = "${aws_route53_zone.public.name_servers}"
}
