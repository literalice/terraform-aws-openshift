output "bastion_public_dns" {
  value = "${aws_route53_record.bastion_public.name}"
}