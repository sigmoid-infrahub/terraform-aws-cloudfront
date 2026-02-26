output "distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.this.id
}

output "domain_name" {
  description = "CloudFront domain name"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "origin_access_control_id" {
  description = "Origin access control ID"
  value       = local.origin_access_control_id
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN"
  value       = local.acm_certificate_arn
}

output "module" {
  description = "Full module outputs"
  value = {
    distribution_id          = aws_cloudfront_distribution.this.id
    domain_name              = aws_cloudfront_distribution.this.domain_name
    origin_access_control_id = local.origin_access_control_id
    acm_certificate_arn      = local.acm_certificate_arn
  }
}
