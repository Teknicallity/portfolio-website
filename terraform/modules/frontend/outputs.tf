output "cloudfront_distribution_url" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}
output "public_url" {
  value = cloudflare_dns_record.subdomain_cname.name
}