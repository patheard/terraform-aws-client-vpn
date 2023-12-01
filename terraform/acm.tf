resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "this" {
  private_key_pem       = tls_private_key.this.private_key_pem
  validity_period_hours = 43800 # 5 years
  early_renewal_hours   = 168   # Generate new cert if Terraform is run within 1 week of expiry

  subject {
    common_name = "vpn.digital.canada.ca"
  }

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "ipsec_end_system",
    "ipsec_tunnel",
    "any_extended",
    "cert_signing",
  ]
}

resource "aws_acm_certificate" "this" {
  private_key      = tls_private_key.this.private_key_pem
  certificate_body = tls_self_signed_cert.this.cert_pem
}