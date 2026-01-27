# Module: CloudFront

This module sets up an AWS CloudFront distribution for content delivery, supporting multiple origins, cache behaviors, and WAF integration.

## Features
- Multi-origin support (S3, ALB, etc.)
- Origin Failover (Origin Groups)
- Customizable Default and Ordered Cache Behaviors
- WAF Web ACL integration
- Viewer Certificate (SSL/TLS) management
- Geo-restriction and Logging support

## Usage
```hcl
module "cloudfront" {
  source = "../../terraform-modules/terraform-aws-cloudfront"

  origins = {
    s3_origin = {
      domain_name = "my-bucket.s3.amazonaws.com"
      origin_id   = "S3-Origin"
    }
  }

  default_cache_behavior = {
    target_origin_id       = "S3-Origin"
    viewer_protocol_policy = "redirect-to-https"
  }
}
```

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| `aliases` | `list(string)` | `[]` | Aliases for the distribution |
| `comment` | `string` | `null` | Distribution comment |
| `default_root_object` | `string` | `null` | Default root object |
| `enabled` | `bool` | `true` | Enable distribution |
| `http_version` | `string` | `"http2and3"` | HTTP version |
| `is_ipv6_enabled` | `bool` | `true` | Enable IPv6 |
| `price_class` | `string` | `"PriceClass_All"` | Price class |
| `retain_on_delete` | `bool` | `false` | Retain on delete |
| `wait_for_deployment` | `bool` | `true` | Wait for deployment |
| `web_acl_id` | `string` | `null` | WAF web ACL ID |
| `origins` | `any` | n/a | Origins configuration |
| `origin_groups` | `any` | `[]` | Origin groups |
| `default_cache_behavior` | `any` | n/a | Default cache behavior |
| `ordered_cache_behaviors` | `any` | `[]` | Ordered cache behaviors |
| `viewer_certificate` | `any` | `null` | Viewer certificate |
| `custom_error_responses` | `any` | `[]` | Custom error responses |
| `geo_restriction` | `any` | `null` | Geo restriction |
| `logging_config` | `any` | `null` | Logging config |
| `tags` | `map(string)` | `{}` | Tags to apply |

## Outputs
| Name | Description |
|------|-------------|
| `distribution_id` | CloudFront distribution ID |
| `domain_name` | CloudFront domain name |
| `module` | Full module outputs |

## Environment Variables
None

## Notes
- `origins` and `default_cache_behavior` are required inputs.
- Ensure the `web_acl_id` is for a WAFv2 Web ACL with `CLOUDFRONT` scope if used.
