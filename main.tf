resource "aws_cloudfront_origin_access_control" "this" {
  count = var.create_origin_access_control ? 1 : 0

  name                              = coalesce(var.origin_access_control_name, "cloudfront-oac")
  description                       = "Managed by terraform-aws-cloudfront module"
  origin_access_control_origin_type = var.origin_access_control_origin_type
  signing_behavior                  = var.origin_access_control_signing_behavior
  signing_protocol                  = var.origin_access_control_signing_protocol
}

resource "aws_acm_certificate" "cloudfront" {
  count = var.domain_name != null && var.create_acm_certificate ? 1 : 0

  provider                  = aws.us_east_1
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cloudfront_cert_validation" {
  for_each = var.domain_name != null && var.create_acm_certificate ? {
    for dvo in aws_acm_certificate.cloudfront[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.hosted_zone_id
}

resource "aws_acm_certificate_validation" "cloudfront" {
  count = var.domain_name != null && var.create_acm_certificate ? 1 : 0

  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.cloudfront[0].arn
  validation_record_fqdns = [for record in aws_route53_record.cloudfront_cert_validation : record.fqdn]
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  comment             = var.comment
  default_root_object = var.default_root_object
  price_class         = var.price_class
  web_acl_id          = var.web_acl_id
  http_version        = var.http_version
  retain_on_delete    = var.retain_on_delete
  wait_for_deployment = var.wait_for_deployment

  aliases = var.domain_name != null ? concat([var.domain_name], var.subject_alternative_names) : var.aliases

  dynamic "origin" {
    for_each = var.origins
    content {
      domain_name              = origin.value.domain_name
      origin_id                = origin.value.origin_id
      origin_path              = lookup(origin.value, "origin_path", null)
      origin_access_control_id = coalesce(lookup(origin.value, "origin_access_control_id", null), local.origin_access_control_id)

      dynamic "custom_header" {
        for_each = lookup(origin.value, "custom_headers", [])
        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }

      dynamic "custom_origin_config" {
        for_each = lookup(origin.value, "custom_origin_config", null) == null ? [] : [origin.value.custom_origin_config]
        content {
          http_port                = custom_origin_config.value.http_port
          https_port               = custom_origin_config.value.https_port
          origin_protocol_policy   = custom_origin_config.value.origin_protocol_policy
          origin_ssl_protocols     = custom_origin_config.value.origin_ssl_protocols
          origin_keepalive_timeout = lookup(custom_origin_config.value, "origin_keepalive_timeout", null)
          origin_read_timeout      = lookup(custom_origin_config.value, "origin_read_timeout", null)
        }
      }
    }
  }

  dynamic "origin_group" {
    for_each = var.origin_groups
    content {
      origin_id = origin_group.value.origin_id

      failover_criteria {
        status_codes = origin_group.value.failover_criteria.status_codes
      }

      dynamic "member" {
        for_each = origin_group.value.member
        content {
          origin_id = member.value.origin_id
        }
      }
    }
  }

  default_cache_behavior {
    target_origin_id           = var.default_cache_behavior.target_origin_id
    viewer_protocol_policy     = var.default_cache_behavior.viewer_protocol_policy
    allowed_methods            = var.default_cache_behavior.allowed_methods
    cached_methods             = var.default_cache_behavior.cached_methods
    compress                   = var.default_cache_behavior.compress
    cache_policy_id            = var.default_cache_behavior.cache_policy_id
    origin_request_policy_id   = var.default_cache_behavior.origin_request_policy_id
    response_headers_policy_id = lookup(var.default_cache_behavior, "response_headers_policy_id", null)

    dynamic "function_association" {
      for_each = lookup(var.default_cache_behavior, "function_associations", [])
      content {
        event_type   = function_association.value.event_type
        function_arn = function_association.value.function_arn
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behaviors
    content {
      path_pattern             = ordered_cache_behavior.value.path_pattern
      target_origin_id         = ordered_cache_behavior.value.target_origin_id
      viewer_protocol_policy   = ordered_cache_behavior.value.viewer_protocol_policy
      allowed_methods          = ordered_cache_behavior.value.allowed_methods
      cached_methods           = ordered_cache_behavior.value.cached_methods
      compress                 = ordered_cache_behavior.value.compress
      cache_policy_id          = lookup(ordered_cache_behavior.value, "cache_policy_id", null)
      origin_request_policy_id = lookup(ordered_cache_behavior.value, "origin_request_policy_id", null)
      min_ttl                  = lookup(ordered_cache_behavior.value, "min_ttl", null)
      default_ttl              = lookup(ordered_cache_behavior.value, "default_ttl", null)
      max_ttl                  = lookup(ordered_cache_behavior.value, "max_ttl", null)
    }
  }

  viewer_certificate {
    acm_certificate_arn            = local.acm_certificate_arn
    ssl_support_method             = var.domain_name != null ? "sni-only" : null
    minimum_protocol_version       = var.domain_name != null ? "TLSv1.2_2021" : null
    cloudfront_default_certificate = var.domain_name == null
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_responses
    content {
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
    }
  }

  dynamic "restrictions" {
    for_each = var.geo_restriction == null ? [] : [var.geo_restriction]
    content {
      geo_restriction {
        restriction_type = restrictions.value.restriction_type
        locations        = lookup(restrictions.value, "locations", [])
      }
    }
  }

  dynamic "logging_config" {
    for_each = var.logging_config == null ? [] : [var.logging_config]
    content {
      bucket          = logging_config.value.bucket
      prefix          = lookup(logging_config.value, "prefix", null)
      include_cookies = lookup(logging_config.value, "include_cookies", null)
    }
  }

  tags = local.resolved_tags
}
