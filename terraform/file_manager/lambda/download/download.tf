resource "aws_lambda_function" "download_function" {
  function_name    = "download_function"
  runtime          = "python3.8"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "index.lambda_handler"
  source_code_hash = base64sha256(file("download_function.zip"))
  filename = "download_function.zip"

  environment {
    variables = {
      ARTIFACTORY_BASE_URL = var.artifactory_base_url
      ARTIFACTORY_REPO = var.artifactory_repo
    }
  }
}