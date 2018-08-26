output "certificate_pem" {
  value = "${acme_certificate.platform_domain.certificate_pem}"
}

output "certificate_key" {
  value = "${tls_private_key.platform_domain_csr.private_key_pem}"
}

output "certificate_intermediate_pem" {
  value = "${acme_certificate.platform_domain.issuer_pem}"
}
