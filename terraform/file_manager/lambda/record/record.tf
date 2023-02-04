resource "aws_lambda_function" "record_saver_function" {
  function_name    = "record_saver_function"
  runtime          = "python3.8"
  role             = aws_iam_role.record_saver_role.arn
  handler          = "index.lambda_handler"
  source_code_hash = base64sha256(file("record_saver.zip"))
  filename = "record_saver.zip"

  environment {
    variables = {
      ARTIFACTORY_BASE_URL = var.artifactory_base_url
      ARTIFACTORY_REPO = var.artifactory_repo
      DYNAMODB_TABLE_NAME = aws_dynamodb_table.uploaded_files_table.name
    }
  }
}