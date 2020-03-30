resource "aws_s3_bucket" "code-build-artifacts" {
  bucket = "${var.organization}-${var.name}-code-build"
  acl = "private"
}
