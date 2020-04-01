locals {
  bucket_name = "${var.organization}-${var.name}-code-build"
}

resource "aws_s3_bucket" "code-build-artifacts" {
  bucket = local.bucket_name
  acl = "private"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.development_account_id}:root"
            },
            "Action": [
                "s3:GetObject",
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::${local.bucket_name}",
                "arn:aws:s3:::${local.bucket_name}/*"
            ]
        }
    ]
}
EOF
}
