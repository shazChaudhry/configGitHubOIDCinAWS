variable "environment" {
  type        = string
  description = "Environment area, e.g. prod or preprod "
}

variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "AWS region (London) where resources deployed to"
}

variable "s3_bucket_name" {
  type        = string
  description = "This bucket contains terraform states created by github actions"
}




