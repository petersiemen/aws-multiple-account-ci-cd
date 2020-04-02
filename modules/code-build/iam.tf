resource "aws_iam_role" "codebuild-role" {
  name = "${local.code_build_name}-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild-role" {
  role = aws_iam_role.codebuild-role.name
  name = "${local.code_build_name}-policy"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": ["kms:*"],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
          "arn:aws:codecommit:${var.aws_region}:${var.aws_account_id}:${var.code_commit_repository_name}"
      ],
      "Action": [
          "codecommit:GitPull"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${var.code_build_artifacts_arn}",
        "${var.code_build_artifacts_arn}/*"
      ]
    }
  ]
}
POLICY
}

