provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Creator     = "Terraform"
      Environment = var.environment
      Service     = "myService"
    }
  }
}

terraform {
  backend "local" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # version = "~> 5.5"
    }
  }
}

# Craete OIDC provide in AWS account. There can be only one per account
module "iam-github-oidc-provider" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
  # version = "~> 5.28"
}

# Attach permissions to the OIDC provider and specify OIDC subjects
module "iam-assumable-role-with-oidc" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  # version = "~> 5.28"

  provider_url                   = module.iam-github-oidc-provider.url
  oidc_fully_qualified_audiences = ["sts.amazonaws.com"]
  # GitHub workflow would be run from all repos within this organization
  # as no specific repo is splied
  oidc_subjects_with_wildcards   = ["repo:Organization/*"]
  create_role                    = true
  role_name                      = "role-with-oidc"
  role_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]
}

# A bucket where GH actions will save terraform states for a given environment like dev
module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  # version = "~> 3.14"

  bucket = var.s3_bucket_name

  server_side_encryption_configuration = {
    rule = {
      bucket_key_enabled = true
      apply_server_side_encryption_by_default = {
        sse_algorithm  = "AES256"
      }
    }
  }
}

# This table is to be used for locking TF runs for a given environment
module "dynamodb-table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  # version = "~> 3.3"

  name     = "terraform-state-lock"
  hash_key = "LockID"

  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]
}
