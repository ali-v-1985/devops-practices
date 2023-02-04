resource "aws_s3_bucket" "uploaded_files" {
  bucket = "uploaded-files"
}

resource "aws_s3_bucket_notification" "uploaded_files-trigger" {
  bucket = aws_s3_bucket.uploaded_files.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.record_saver_function.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "file-prefix"
    filter_suffix       = "file-extension"
  }
}