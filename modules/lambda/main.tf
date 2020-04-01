resource "aws_lambda_function" "lambda-api-gateway" {
  function_name = "lambda-api-gateway"

  s3_bucket = var.s3_bucket
  s3_key    = var.s3_key

  handler = var.handler
  runtime = "python3.7"

  role = aws_iam_role.lambda-exec.arn
}


resource "aws_iam_role" "lambda-exec" {
  name = "lambda-api-gateway"

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


resource "aws_iam_policy" "update-security-groups-policy" {
  name        = "lambda-api-gateway"
  description = "lambda-api-gateway"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:CreateLogGroup",
                 "logs:CreateLogStream",
                 "logs:PutLogEvents"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": "ses:SendEmail",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda-update-security-groups" {
  policy_arn = aws_iam_policy.update-security-groups-policy.arn
  role       = aws_iam_role.lambda-exec.id
}

