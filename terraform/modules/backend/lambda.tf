data "archive_file" "get_views_zip" {
  type = "zip"
  source_file = "${path.root}/../backend/lambda/get_views.py"
  output_path = "${path.root}/build/get_views_function.zip"
}
data "archive_file" "increment_views_zip" {
  type = "zip"
  source_file = "${path.root}/../backend/lambda/increment_views.py"
  output_path = "${path.root}/build/increment_views.zip"
}

resource "aws_lambda_function" "get_views" {
  function_name = "getViewsFunctionTf${var.subdomain}"
  handler       = "get_views.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_exec.arn
  filename      = data.archive_file.get_views_zip.output_path

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.visitor_count.name
    }
  }
}

resource "aws_lambda_function" "increment_views" {
  function_name = "incrementViewsFunctionTf${var.subdomain}"
  handler       = "increment_views.lambda_handler"
  runtime       = "python3.13"
  role          = aws_iam_role.lambda_exec.arn
  filename      = data.archive_file.increment_views_zip.output_path

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.visitor_count.name
    }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role_${var.subdomain}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "lambda_dynamodb_access" {
  name = "LambdaDynamoDBAccessPolicy${var.subdomain}TF"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ],
        Effect   = "Allow",
        Resource = aws_dynamodb_table.visitor_count.arn
      },
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ],
        Effect   = "Allow",
        Resource = aws_dynamodb_table.visitor_count.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_dynamodb_access.arn
}