
resource "aws_s3_bucket" "website_bucket" {
  bucket = "${var.bucket_name}${var.subdomain}"
}

resource "aws_s3_bucket_ownership_controls" "bucket_acl_ownership" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

data "aws_iam_policy_document" "cf_access" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website_bucket.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "cf_access" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.cf_access.json
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id
  index_document {
    suffix = "index.html"
  }
}

locals {
  mime_types = {
    html = "text/html"
    css  = "text/css"
    js   = "application/javascript"
    json = "application/json"
    png  = "image/png"
    jpg  = "image/jpeg"
    svg  = "image/svg+xml"
    ico  = "image/x-icon"
  }
}

resource "aws_s3_object" "static_files" {
  for_each        = fileset("${path.root}/../../frontend/dist/", "**")
  bucket          = aws_s3_bucket.website_bucket.id
  key             = each.value
  source          = "${path.root}/../../frontend/dist/${each.value}"
  content_type    = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1], "binary/octet-stream")
  etag            = filemd5("${path.root}/../../frontend/dist/${each.value}")
}


data "template_file" "config_js" {
  template = file("${path.module}/config.js.tpl")
  vars = {
    api_url = var.increment_api_url
  }
}

resource "aws_s3_object" "config_js" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "config.js"
  content = data.template_file.config_js.rendered
  content_type = "application/javascript"
}