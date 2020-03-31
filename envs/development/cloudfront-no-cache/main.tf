variable "shared_services_account_id" {}

variable "certificates__acm_certification_arn" {}
variable "s3_static_website__bucket_name" {}
variable "s3_static_website__website_endpoint" {}
variable "s3_static_website__bucket_regional_domain_name" {}

module "cloudfront-no-cache" {
  source = "../../../modules/cloudfront-no-cache"
  acm_certification_arn = var.certificates__acm_certification_arn
  aliases = [
    "www.${var.s3_static_website__bucket_name}",
    var.s3_static_website__bucket_name]
  website_endpoint = var.s3_static_website__website_endpoint
  bucket_regional_domain_name = var.s3_static_website__bucket_regional_domain_name
  name = var.s3_static_website__bucket_name
}


data "aws_route53_zone" "main" {
  provider = aws.shared-services
  name = "petersiemen.de"
}

resource "aws_route53_record" "www" {
  provider = aws.shared-services
  zone_id = data.aws_route53_zone.main.zone_id
  name = "www.preview"
  type = "A"

  alias {
    name = module.cloudfront-no-cache.domain_name
    zone_id = module.cloudfront-no-cache.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "apex" {
  provider = aws.shared-services
  zone_id = data.aws_route53_zone.main.zone_id
  name = "preview"
  type = "A"

  alias {
    name = module.cloudfront-no-cache.domain_name
    zone_id = module.cloudfront-no-cache.hosted_zone_id
    evaluate_target_health = false
  }
}
