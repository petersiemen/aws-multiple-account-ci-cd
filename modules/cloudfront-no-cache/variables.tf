variable "name" {}
variable "bucket_regional_domain_name" {}
variable "aliases" {
  type = list(string)
}
variable "acm_certification_arn" {}