terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_dns_record" "ssl_cert_validation" {
  depends_on = [aws_acm_certificate.ssl_cert]

  for_each = {
    for dvo in aws_acm_certificate.ssl_cert.domain_validation_options :
    dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  comment = "ACM validation for ${var.subdomain} from terraform"
  zone_id = var.zone_id
  name    = each.value.name
  type    = each.value.type
  content = each.value.value
  proxied = false
  ttl     = 60

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    ignore_changes        = [
      ttl,
      proxied
    ]
  }
}

resource "cloudflare_dns_record" "subdomain_cname" {
  comment = "CloudFront alias from terraform"
  zone_id = var.zone_id
  name    = "${var.subdomain}.${var.domain}"
  content = aws_cloudfront_distribution.s3_distribution.domain_name
  type    = "CNAME"
  proxied = false
  ttl     = 1
}