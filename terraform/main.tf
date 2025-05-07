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
}

module "backend" {
  source = "./modules/backend"
}

module "frontend" {
  source      = "./modules/frontend"
  bucket_name = "sheputa-portfolio-website-tf"
  domain_name = "josh.cacaw.group"
}