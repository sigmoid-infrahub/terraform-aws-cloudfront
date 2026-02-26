variable "aliases" {
  type        = list(string)
  description = "Aliases for the distribution"
  default     = []
}

variable "comment" {
  type        = string
  description = "Distribution comment"
  default     = null
}

variable "default_root_object" {
  type        = string
  description = "Default root object"
  default     = null
}

variable "enabled" {
  type        = bool
  description = "Enable distribution"
  default     = true
}

variable "http_version" {
  type        = string
  description = "HTTP version"
  default     = "http2and3"
}

variable "is_ipv6_enabled" {
  type        = bool
  description = "Enable IPv6"
  default     = true
}

variable "price_class" {
  type        = string
  description = "Price class"
  default     = "PriceClass_All"
}

variable "retain_on_delete" {
  type        = bool
  description = "Retain on delete"
  default     = false
}

variable "wait_for_deployment" {
  type        = bool
  description = "Wait for deployment"
  default     = true
}

variable "web_acl_id" {
  type        = string
  description = "WAF web ACL ID"
  default     = null
}

variable "origin_access_control_id" {
  type        = string
  description = "External origin access control ID"
  default     = null
}

variable "create_origin_access_control" {
  type        = bool
  description = "Create origin access control"
  default     = false
}

variable "origin_access_control_name" {
  type        = string
  description = "Origin access control name"
  default     = null
}

variable "origin_access_control_origin_type" {
  type        = string
  description = "Origin access control origin type"
  default     = "s3"
}

variable "origin_access_control_signing_behavior" {
  type        = string
  description = "Origin access control signing behavior"
  default     = "always"
}

variable "origin_access_control_signing_protocol" {
  type        = string
  description = "Origin access control signing protocol"
  default     = "sigv4"
}

variable "domain_name" {
  type        = string
  description = "Primary custom domain for CloudFront"
  default     = null
}

variable "subject_alternative_names" {
  type        = list(string)
  description = "Additional domain names for ACM certificate"
  default     = []
}

variable "create_acm_certificate" {
  type        = bool
  description = "Create ACM certificate for CloudFront"
  default     = true
}

variable "acm_certificate_arn" {
  type        = string
  description = "External ACM certificate ARN for CloudFront"
  default     = null
}

variable "hosted_zone_id" {
  type        = string
  description = "Route53 hosted zone ID for certificate validation"
  default     = null
}

variable "origins" {
  type        = any
  description = "Origins configuration"
}

variable "origin_groups" {
  type        = any
  description = "Origin groups"
  default     = []
}

variable "default_cache_behavior" {
  type        = any
  description = "Default cache behavior"
}

variable "ordered_cache_behaviors" {
  type        = any
  description = "Ordered cache behaviors"
  default     = []
}

variable "viewer_certificate" {
  type        = any
  description = "Viewer certificate"
  default     = null
}

variable "custom_error_responses" {
  type        = any
  description = "Custom error responses"
  default     = []
}

variable "geo_restriction" {
  type        = any
  description = "Geo restriction"
  default     = null
}

variable "logging_config" {
  type        = any
  description = "Logging config"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
  default     = {}
}
