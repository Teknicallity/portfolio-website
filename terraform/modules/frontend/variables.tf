variable "bucket_name" {
  type = string
  description = "Name of the bucket."
}
variable "cloudflare_api_token" {
  type = string
  description = "Cloudflare account api token"
}
variable "zone_id" {
  type = string
}
variable "account_id" {
  type = string
}
variable "subdomain" {
  type = string
}
variable "domain" {
  type = string
}
variable "increment_api_url" {
  type = string
}