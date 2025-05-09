output "api_gateway_increment_views_url" {
  value = "${aws_api_gateway_stage.prod.invoke_url}${aws_api_gateway_resource.increment_views.path}"
}
output "api_gateway_get_views_url" {
  value = "${aws_api_gateway_stage.prod.invoke_url}${aws_api_gateway_resource.get_views.path}"
}