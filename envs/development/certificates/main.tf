locals {
  domain = "preview.petersiemen.de"
}

module "certificates" {
  providers = {
    aws.us-east-1 = aws.us-east-1
    aws.shared-services = aws.shared-services
  }

  source = "../../../modules/certificates"
  domain_name = local.domain
  subject_alternative_names = [
    "www.${local.domain}"
  ]
  zones = [
    "petersiemen.de",
    "petersiemen.de"]
}