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
