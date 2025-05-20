
provider "aws" {
  alias = "us-east-1"
  region = "us-east-1"
}

resource "aws_acm_certificate" "ssl_cert" {
  provider          = aws.us-east-1
  domain_name       = "${var.subdomain}.${var.domain}"
  validation_method = "DNS"

  subject_alternative_names = [
    "${var.subdomain}.${var.domain}"
  ]

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}