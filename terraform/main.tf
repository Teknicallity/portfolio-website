terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.97.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

module "backend" {
  source = "./modules/backend"
  api_gateway_name = var.api_gateway_name
  db_table_name = var.db_table_name
  subdomain = var.subdomain
  domain = var.domain
}

module "frontend" {
  source      = "./modules/frontend"
  bucket_name = var.bucket_name
  subdomain = var.subdomain
  domain = var.domain
  cloudflare_api_token = var.cloudflare_api_token
  account_id = var.account_id
  zone_id = var.zone_id
  increment_api_url = module.backend.api_gateway_increment_views_url
}