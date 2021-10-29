
resource "aws_iam_role" "test_lambda_role" {
  name = "test_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "archive_file" "init" {
  type        = "zip"
  source_file = "${path.module}/hello.py"
  output_path = "${path.module}/files/hello.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "${path.module}/files/hello.zip"
  function_name = "welcome"
  role          = aws_iam_role.test_lambda_role.arn
  handler       = "hello.welcome"
  # source_code_hash = filebase64sha256("test.zip")
  source_code_hash = data.archive_file.init.output_base64sha256
  runtime = "python3.7"
}
