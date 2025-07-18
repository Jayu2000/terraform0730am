variable "bucket" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "acl" {
  description = "The canned ACL to apply"
  type        = string
  default     = "private"
}

variable "control_object_ownership" {
  description = "Enable Object Ownership enforcement"
  type        = bool
  default     = true
}

variable "object_ownership" {
  description = "S3 Object Ownership setting"
  type        = string
  default     = "ObjectWriter"
}

variable "versioning_enabled" {
  description = "Enable versioning on the bucket"
  type        = bool
  default     = true
}
