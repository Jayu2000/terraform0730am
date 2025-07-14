variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "private_subnet_cidrs" {
  description = "CIDRs for two private subnets"
  type        = list(string)
}

variable "db_name" {
  description = "Initial DB name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master DB username"
  type        = string
  default     = "admin"
}

variable "instance_class" {
  description = "instance class subnet group"
  type        = string
  default     = "admin"
}
