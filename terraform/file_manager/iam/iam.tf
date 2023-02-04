resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_exec_role_s3_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.lambda_exec_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_exec_role_dynamodb_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role       = aws_iam_role.lambda_exec_role.name
}

resource "aws_iam_group" "admin_group" {
  name = "admin_group"
}

resource "aws_iam_user_group_membership" "admin_group_membership" {
  user  = aws_iam_user.admin_user.name
  groups = [aws_iam_group.admin_group.name]
}

resource "aws_iam_user" "admin_user" {
  name = "admin_user"
}

resource "aws_iam_access_key" "admin_user_access_key" {
  user = aws_iam_user.admin_user.name
}

resource "aws_iam_group" "uploader_group" {
  name = "uploader_group"
}

resource "aws_iam_user_group_membership" "uploader_group_membership" {
  user  = aws_iam_user.uploader_user.name
  groups = [aws_iam_group.uploader_group.name]
}

resource "aws_iam_user" "uploader_user" {
  name = "uploader_user"
}

resource "aws_iam_access_key" "uploader_user_access_key" {
  user = aws_iam_user.uploader_user.name
}

resource "aws_iam_group" "downloader_group" {
  name = "downloader_group"
}

resource "aws_iam_user_group_membership" "downloader_group_membership" {
  user  = aws_iam_user.downloader_user.name
  groups = [aws_iam_group.downloader_group.name]
}

resource "aws_iam_user" "downloader_user" {
  name = "downloader_user"
}

resource "aws_iam_access_key" "downloader_user_access_key" {
  user = aws_iam_user.downloader_user.name
}

resource "aws_iam_role" "record_saver_role" {
  name = "record_saver_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "record_saver_policy" {
  name = "record_saver_policy"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:PutItem"
        ],
        Effect   = "Allow",
        Resource = aws_dynamodb_table.uploaded_files_table.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "record_saver_policy_attachment" {
  policy_arn = aws_iam_policy.record_saver_policy.arn
  role       = aws_iam_role.record_saver_role.name
}

resource "aws_iam_group_policy_attachment" "admin_group_policy_attachment" {
  group      = aws_iam_group.admin_group.name
  policy_arn = aws_iam_policy.admin_policy.arn
}

resource "aws_iam_policy" "admin_policy" {
  name = "admin_policy"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action   = "",
        Effect   = "Allow",
        Resource = ""
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "uploader_group_policy_attachment" {
  group      = aws_iam_group.uploader_group.name
  policy_arn = aws_iam_policy.uploader_policy.arn
}

resource "aws_iam_policy" "uploader_policy" {
  name = "uploader_policy"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction",
          "kinesis:PutRecord"
        ],
        Effect   = "Allow",
        Resource = [
          aws_lambda_function.upload_function.arn,
          #          aws_kinesis_firehose_delivery_stream.uploaded_files_stream.arn
        ]
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "downloader_group_policy_attachment" {
  group      = aws_iam_group.downloader_group.name
  policy_arn = aws_iam_policy.downloader_policy.arn
}

resource "aws_iam_policy" "downloader_policy" {
  name = "downloader_policy"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction",
          "dynamodb:GetItem"
        ],
        Effect   = "Allow",
        Resource = [
          aws_lambda_function.download_function.arn,
          aws_dynamodb_table.uploaded_files_table.arn
        ]
      }
    ]
  })
}

resource "aws_lambda_permission" "test" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.record_saver_function.function_name
  principal = "s3.amazonaws.com"
  source_arn = "arn:aws:s3:::${aws_s3_bucket.uploaded_files.id}"
}