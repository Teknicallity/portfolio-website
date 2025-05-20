terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.97.0"
    }
  }

  backend "remote" {

    organization = "JSheputa-Portfolio"

    workspaces {
      name = "Portfolio-Prod"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "backend" {
  source = "../modules/backend"
  subdomain = var.subdomain
  domain = var.domain
}

module "frontend" {
  source      = "../modules/frontend"
  subdomain = var.subdomain
  domain = var.domain
  cloudflare_api_token = var.cloudflare_api_token
  account_id = var.account_id
  zone_id = var.zone_id
  increment_api_url = module.backend.api_gateway_increment_views_url
}