output "arn" {
  value = aws_s3_bucket.code-build-artifacts.arn
}

output "bucket" {
  value = aws_s3_bucket.code-build-artifacts.bucket
}