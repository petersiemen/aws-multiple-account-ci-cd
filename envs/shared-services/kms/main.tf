resource "aws_kms_key" "artifacts-key" {}
resource "aws_kms_alias" "alias" {
  name = "alias/artifacts"
  target_key_id = aws_kms_key.artifacts-key.key_id
}
