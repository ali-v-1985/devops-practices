resource "aws_api_gateway_rest_api" "upload_api" {
  name = "upload_api"
}

resource "aws_api_gateway_resource" "upload_api_root_resource" {
  rest_api_id = aws_api_gateway_rest_api.upload_api.id
  parent_id   = aws_api_gateway_rest_api.upload_api.root_resource_id
  path_part   = "upload"
}

resource "aws_api_gateway_method" "upload_api_post_method" {
  rest_api_id   = aws_api_gateway_rest_api.upload_api.id
  resource_id   = aws_api_gateway_resource.upload_api_root_resource.id
  http_method   = "POST"
  authorization = "IAM"
}

resource "aws_api_gateway_integration" "upload_api_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.upload_api.id
  resource_id = aws_api_gateway_resource.upload_api_root_resource.id
  http_method = aws_api_gateway_method.upload_api_post_method.http_method
  type        = "AWS_PROXY"
  uri         = aws_lambda_function.upload_function.invoke_arn
}

resource "aws_api_gateway_rest_api" "download_api" {
  name = "download_api"
}

resource "aws_api_gateway_resource" "download_api_root_resource" {
  rest_api_id = aws_api_gateway_rest_api.download_api.id
  parent_id   = aws_api_gateway_rest_api.download_api.root_resource_id
  path_part   = "download"
}

resource "aws_api_gateway_method" "download_api_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.download_api.id
  resource_id   = aws_api_gateway_resource.download_api_root_resource.id
  http_method   = "GET"
  authorization = "IAM"
}

resource "aws_api_gateway_integration" "download_api_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.download_api.id
  resource_id = aws_api_gateway_resource.download_api_root_resource.id
  http_method = aws_api_gateway_method.download_api_get_method.http_method
  type        = "AWS_PROXY"
  uri         = aws_lambda_function.download_function.invoke_arn
}

resource "aws_api_gateway_deployment" "upload_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.upload_api_lambda_integration,
    aws_api_gateway_method.upload_api_post_method,
  ]

  rest_api_id = aws_api_gateway_rest_api.upload_api.id
  stage_name  = "prod"
}

resource "aws_api_gateway_deployment" "download_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.download_api_lambda_integration,
    aws_api_gateway_method.download_api_get_method,
  ]

  rest_api_id = aws_api_gateway_rest_api.download_api.id
  stage_name  = "prod"
}

resource "aws_api_gateway_rest_api" "file_upload_api" {
  name = "file_upload_api"
}

resource "aws_api_gateway_resource" "upload_file_resource" {
  rest_api_id = aws_api_gateway_rest_api.file_upload_api.id
  parent_id   = aws_api_gateway_rest_api.file_upload_api.root_resource_id
  path_part   = "upload-file"
}

resource "aws_api_gateway_method" "upload_file_method" {
  rest_api_id   = aws_api_gateway_rest_api.file_upload_api.id
  resource_id   = aws_api_gateway_resource.upload_file_resource.id
  http_method   = "POST"
  authorization = "IAM"
}

resource "aws_api_gateway_integration" "upload_file_integration" {
  rest_api_id             = aws_api_gateway_rest_api.file_upload_api.id
  resource_id             = aws_api_gateway_resource.upload_file_resource.id
  http_method             = aws_api_gateway_method.upload_file_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.upload_function.invoke_arn
}

resource "aws_api_gateway_rest_api" "file_download_api" {
  name = "file_download_api"
}

resource "aws_api_gateway_resource" "download_file_resource" {
  rest_api_id = aws_api_gateway_rest_api.file_download_api.id
  parent_id   = aws_api_gateway_rest_api.file_download_api.root_resource_id
  path_part   = "download-file"
}

resource "aws_api_gateway_method" "download_file_method" {
  rest_api_id   = aws_api_gateway_rest_api.file_download_api.id
  resource_id   = aws_api_gateway_resource.download_file_resource.id
  http_method   = "GET"
  authorization = "IAM"
}

resource "aws_api_gateway_integration" "download_file_integration" {
  rest_api_id             = aws_api_gateway_rest_api.file_download_api.id
  resource_id             = aws_api_gateway_resource.download_file_resource.id
  http_method             = aws_api_gateway_method.download_file_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.download_function.invoke_arn
}

output "upload_file_endpoint" {
  value = aws_api_gateway_deployment.upload_api_deployment.invoke_url
}

output "download_file_endpoint" {
  value = aws_api_gateway_deployment.download_api_deployment.invoke_url
}