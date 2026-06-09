locals {
  # AWS-managed "CachingOptimized" cache policy id (global, identical across all accounts).
  # Default when no cache_policy_id is provided: a cache behavior must have either a
  # cache_policy_id or a legacy forwarded_values block, else AWS rejects CreateDistribution
  # with "ForwardedValues is required".
  managed_caching_optimized_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

  origin_access_control_id = var.create_origin_access_control ? aws_cloudfront_origin_access_control.this[0].id : var.origin_access_control_id
  acm_certificate_arn = (
    var.domain_name == null ? (var.viewer_certificate != null ? lookup(var.viewer_certificate, "acm_certificate_arn", null) : null) :
    var.create_acm_certificate ? aws_acm_certificate_validation.cloudfront[0].certificate_arn : var.acm_certificate_arn
  )
  has_logging_bucket = length(trimspace(var.logging_bucket)) > 0
  logging_config_effective = var.enable_logging ? {
    bucket          = var.logging_bucket
    prefix          = "cloudfront/"
    include_cookies = false
  } : var.logging_config

  sigmoid_tags = merge(
    var.sigmoid_environment != "" ? { "sigmoid:environment" = var.sigmoid_environment } : {},
    var.sigmoid_project != "" ? { "sigmoid:project" = var.sigmoid_project } : {},
    var.sigmoid_team != "" ? { "sigmoid:team" = var.sigmoid_team } : {},
  )



  resolved_tags = merge({
    ManagedBy = "sigmoid"
  }, var.tags, local.sigmoid_tags)
}
