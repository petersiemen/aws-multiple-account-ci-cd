output "key_id" {
  value = aws_kms_key.artifacts-key.key_id
}

output "key_alias_arn" {
  value = aws_kms_alias.alias.arn
}