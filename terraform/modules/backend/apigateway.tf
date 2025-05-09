# ---------------------------
# API Gateway REST API
# ---------------------------
resource "aws_api_gateway_rest_api" "view_api" {
  name = var.api_gateway_name
}

# ---------------------------
# Root Resource Reference
# ---------------------------
data "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.view_api.id
  path        = "/"
}

# ---------------------------
# /getViews Endpoint
# ---------------------------
resource "aws_api_gateway_resource" "get_views" {
  rest_api_id = aws_api_gateway_rest_api.view_api.id
  parent_id   = data.aws_api_gateway_resource.root.id
  path_part   = "getViews"
}

resource "aws_api_gateway_method" "get_views_get" {
  rest_api_id   = aws_api_gateway_rest_api.view_api.id
  resource_id   = aws_api_gateway_resource.get_views.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_views_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.view_api.id
  resource_id             = aws_api_gateway_resource.get_views.id
  http_method             = aws_api_gateway_method.get_views_get.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.get_views.invoke_arn
  timeout_milliseconds    = 5000
}

resource "aws_api_gateway_method_response" "get_views_get_response" {
  depends_on = [aws_api_gateway_method.get_views_get]
  rest_api_id = aws_api_gateway_rest_api.view_api.id
  resource_id = aws_api_gateway_resource.get_views.id
  http_method = "GET"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "get_views_get_response" {
  depends_on = [aws_api_gateway_integration.get_views_lambda, aws_api_gateway_method_response.get_views_get_response]
  rest_api_id = aws_api_gateway_rest_api.view_api.id
  resource_id = aws_api_gateway_resource.get_views.id
  http_method = "GET"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'https://${var.subdomain}.${var.domain}'"
  }

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_lambda_permission" "get_views_api" {
  depends_on = [
    aws_api_gateway_method.get_views_get,
    aws_api_gateway_integration.get_views_lambda
  ]

  statement_id  = "AllowAPIGatewayInvokeGetViews"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_views.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.view_api.execution_arn}/*/*"
}

# ---------------------------
# /incrementViews Endpoint
# ---------------------------
resource "aws_api_gateway_resource" "increment_views" {
  rest_api_id = aws_api_gateway_rest_api.view_api.id
  parent_id   = data.aws_api_gateway_resource.root.id
  path_part   = "incrementViews"
}

resource "aws_api_gateway_method" "increment_views_post" {
  rest_api_id   = aws_api_gateway_rest_api.view_api.id
  resource_id   = aws_api_gateway_resource.increment_views.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "increment_views_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.view_api.id
  resource_id             = aws_api_gateway_resource.increment_views.id
  http_method             = aws_api_gateway_method.increment_views_post.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.increment_views.invoke_arn
  timeout_milliseconds    = 5000
}

resource "aws_api_gateway_method_response" "increment_views_post_response" {
  depends_on = [aws_api_gateway_method.increment_views_post]
  rest_api_id = aws_api_gateway_rest_api.view_api.id
  resource_id = aws_api_gateway_resource.increment_views.id
  http_method = "POST"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "increment_views_post_response" {
  depends_on = [aws_api_gateway_integration.increment_views_lambda, aws_api_gateway_method_response.increment_views_post_response]
  rest_api_id = aws_api_gateway_rest_api.view_api.id
  resource_id = aws_api_gateway_resource.increment_views.id
  http_method = "POST"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'https://${var.subdomain}.${var.domain}'"
  }

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_method" "increment_views_options" {
  rest_api_id   = aws_api_gateway_rest_api.view_api.id
  resource_id   = aws_api_gateway_resource.increment_views.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "increment_views_options_mock" {
  depends_on  = [aws_api_gateway_method.increment_views_options]
  rest_api_id = aws_api_gateway_rest_api.view_api.id
  resource_id = aws_api_gateway_resource.increment_views.id
  http_method = "OPTIONS"
  type        = "MOCK"

  request_templates = {
    "application/json" = <<EOF
{
  "statusCode": 200
}
EOF
  }
}

resource "aws_api_gateway_method_response" "increment_views_options_response" {
  depends_on = [aws_api_gateway_method.increment_views_options]
  rest_api_id = aws_api_gateway_rest_api.view_api.id
  resource_id = aws_api_gateway_resource.increment_views.id
  http_method = "OPTIONS"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "increment_views_options_response" {
  depends_on = [
    aws_api_gateway_method_response.increment_views_options_response,
    aws_api_gateway_integration.increment_views_options_mock
  ]
  rest_api_id = aws_api_gateway_rest_api.view_api.id
  resource_id = aws_api_gateway_resource.increment_views.id
  http_method = "OPTIONS"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'https://${var.subdomain}.${var.domain}'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  }

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_lambda_permission" "increment_views_api" {
  depends_on = [
    aws_api_gateway_method.increment_views_post,
    aws_api_gateway_integration.increment_views_lambda
  ]

  statement_id  = "AllowAPIGatewayInvokeIncrementViews"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.increment_views.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.view_api.execution_arn}/*/*"
}

# ---------------------------
# Deployment and Stage
# ---------------------------
resource "aws_api_gateway_deployment" "view_api_deployment" {
  depends_on = [
    aws_api_gateway_method.get_views_get,
    aws_api_gateway_integration.get_views_lambda,
    aws_api_gateway_method.increment_views_post,
    aws_api_gateway_integration.increment_views_lambda,
    aws_api_gateway_method.increment_views_options,
    aws_api_gateway_integration.increment_views_options_mock,
    aws_api_gateway_gateway_response.cors_4xx,
    aws_api_gateway_gateway_response.cors_5xx
  ]

  rest_api_id = aws_api_gateway_rest_api.view_api.id

  lifecycle {
    create_before_destroy = true
  }

  # Forces a new deployment on config change
  triggers = {
    redeploy_hash = sha1(join("", [
      jsonencode(aws_api_gateway_integration_response.get_views_get_response.response_parameters),
      jsonencode(aws_api_gateway_integration_response.increment_views_post_response.response_parameters),
      jsonencode(aws_api_gateway_gateway_response.cors_4xx.response_parameters),
      jsonencode(aws_api_gateway_gateway_response.cors_5xx.response_parameters)
    ]))
  }
}

resource "aws_api_gateway_stage" "prod" {
  depends_on = [aws_api_gateway_deployment.view_api_deployment]
  deployment_id = aws_api_gateway_deployment.view_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.view_api.id
  stage_name    = "prod"

  lifecycle {
    prevent_destroy = false
  }
}