locals {
  domain = "petersiemen.de"
}

module "certificates" {
  providers = {
    aws.us-east-1 = aws.us-east-1
  }

  source = "../../../modules/certificates"
  domain_name = local.domain
  subject_alternative_names = [
    "*.${local.domain}"
  ]
  zones = [
    "petersiemen.de"]
}