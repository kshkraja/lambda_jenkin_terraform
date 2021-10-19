
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

resource "aws_lambda_function" "test_lambda" {
  filename      = "test.zip"
  function_name = "lambda_function"
  role          = aws_iam_role.test_lambda_role.arn
  handler       = "index.test"

  
  source_code_hash = filebase64sha256("test.zip")

  runtime = "python3.7"
}