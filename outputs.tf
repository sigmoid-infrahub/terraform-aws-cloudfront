output "distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.this.id
}

output "domain_name" {
  description = "CloudFront domain name"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "module" {
  description = "Full module outputs"
  value = {
    distribution_id = aws_cloudfront_distribution.this.id
    domain_name     = aws_cloudfront_distribution.this.domain_name
  }
}
