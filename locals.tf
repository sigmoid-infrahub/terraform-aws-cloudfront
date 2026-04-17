locals {
  origin_access_control_id = var.create_origin_access_control ? aws_cloudfront_origin_access_control.this[0].id : var.origin_access_control_id
  acm_certificate_arn = (
    var.domain_name == null ? (var.viewer_certificate != null ? var.viewer_certificate.acm_certificate_arn : null) :
    var.create_acm_certificate ? aws_acm_certificate_validation.cloudfront[0].certificate_arn : var.acm_certificate_arn
  )
  sigmoid_tags = merge(
    var.sigmoid_environment != "" ? { "sigmoid:environment" = var.sigmoid_environment } : {},
    var.sigmoid_project != "" ? { "sigmoid:project" = var.sigmoid_project } : {},
    var.sigmoid_team != "" ? { "sigmoid:team" = var.sigmoid_team } : {},
  )



  resolved_tags = merge({
    ManagedBy = "sigmoid"
  }, var.tags, local.sigmoid_tags)
}
