resource "aws_dynamodb_table" "uploaded_files_table" {
  name = "uploaded_files_table"
  hash_key       = "file_id"
  range_key      = "user_name"

  attribute {
    name = "file_id"
    type = "S"
  }

  attribute {
    name = "user_name"
    type = "S"
  }

  attribute {
    name = "file_name"
    type = "S"
  }

  attribute {
    name = "file_size"
    type = "N"
  }

  attribute {
    name = "upload_datetime"
    type = "S"
  }

  attribute {
    name = "file_s3_url"
    type = "S"
  }

  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
}