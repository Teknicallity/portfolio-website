resource "aws_dynamodb_table" "visitor_count" {
  name = var.db_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "PageId"

  attribute {
    name = "PageId"
    type = "S"
  }
}
