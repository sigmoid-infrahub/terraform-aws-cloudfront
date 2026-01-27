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

  aliases = var.aliases

  dynamic "origin" {
    for_each = var.origins
    content {
      domain_name              = origin.value.domain_name
      origin_id                = origin.value.origin_id
      origin_path              = lookup(origin.value, "origin_path", null)
      origin_access_control_id = lookup(origin.value, "origin_access_control_id", null)

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

  dynamic "viewer_certificate" {
    for_each = var.viewer_certificate == null ? [] : [var.viewer_certificate]
    content {
      acm_certificate_arn      = viewer_certificate.value.acm_certificate_arn
      ssl_support_method       = viewer_certificate.value.ssl_support_method
      minimum_protocol_version = viewer_certificate.value.minimum_protocol_version
    }
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

