variable "shared_services_account_id" {}

module "s3-static-website" {
  source = "../../../modules/s3-static-website"
  bucket_name = "petersiemen.de"
  shared_services_account_id = var.shared_services_account_id
}