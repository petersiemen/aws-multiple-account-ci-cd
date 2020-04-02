resource "aws_s3_bucket_policy" "artifacts-bucket-policy" {
  bucket = var.code_build_artifacts_id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
            "AWS": ["arn:aws:iam::${var.development_account_id}:root",
                    "${aws_iam_role.codebuild-role.arn}"]
        },
        "Action": [
            "s3:*"
        ],
        "Resource": [
            "arn:aws:s3:::${var.code_build_artifacts_bucket}",
            "arn:aws:s3:::${var.code_build_artifacts_bucket}/*"
        ]
    }
  ]
}
POLICY
}

