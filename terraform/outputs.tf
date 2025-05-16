# Backend Outputs
output "api_gateway_increment_views_url" {
  value = module.backend.api_gateway_increment_views_url
}
output "api_gateway_get_views_url" {
  value = module.backend.api_gateway_get_views_url
}
output "api_gateway_base_invoke_url" {
  value = module.backend.api_gateway_base_invoke_url
}

# Frontend Outputs
output "cloudfront_distribution_url" {
  value = module.frontend.cloudfront_distribution_url
}
output "public_url" {
  value = module.frontend.public_url
}