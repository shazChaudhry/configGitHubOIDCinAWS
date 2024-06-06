provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Creator     = "Terraform"
      Environment = var.environment
      Service     = "GitHubOIDC"
      GithubRepo  = "https://github.com/shazChaudhry/configGitHubOIDCinAWS"
    }
  }
}

terraform {

  # This backend assumes that both the s3 bucket and DynamoDB already exist
  backend "s3" {
    bucket         = "infra-20240606"
    dynamodb_table = "statefile"
    region         = "eu-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.5"
    }
  }
}

# Craete OIDC provider in AWS account. There can be only one per account
module "iam-github-oidc-provider" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
  version = "~> 5.39"
}

# Attach permissions to the OIDC provider and specify OIDC subjects
module "iam-assumable-role-with-oidc" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 5.39"

  provider_url                   = module.iam-github-oidc-provider.url
  oidc_fully_qualified_audiences = ["sts.amazonaws.com"]
  # GitHub workflow would be run from all repos within this organization
  # as no specific repo is splied
  oidc_subjects_with_wildcards = ["repo:shazChaudhry/*"]
  create_role                  = true
  role_name                    = "role-with-github-oidc"
  role_description             = "IAM role which can be assumed by trusted resources using OpenID Connect Federated Users"
  role_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]
}
