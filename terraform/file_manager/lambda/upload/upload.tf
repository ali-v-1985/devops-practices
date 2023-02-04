resource "aws_lambda_function" "upload_function" {
  function_name    = "upload_function"
  runtime          = "python3.8"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "index.lambda_handler"
  source_code_hash = base64sha256(file("upload_function.zip"))
  filename = "upload_function.zip"

  environment {
    variables = {
      ARTIFACTORY_BASE_URL = var.artifactory_base_url
      ARTIFACTORY_REPO = var.artifactory_repo
      S3_BUCKET = aws_s3_bucket.uploaded_files.id
    }
  }
}