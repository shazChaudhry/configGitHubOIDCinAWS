### Asumtions
- An S3 bucket where Terraform statefile is to be stored already exists
- A DynamoDB table that will be used to lock state of Terraform already exists

### Description
Terraform configuration files in this repo will configure GtHub OpenID Connect (_OIDC_) in AWS. This will be prerequisite to running your project specific GitHub workflows with Terraform within your organization

The following is going to be created in AWS:
- Region is set to be eu-west-2 (London)
- An IAM identity provider for GitHub OIDC
- An IAM role which can be assumed by trusted resources using OpenID Connect Federated Users. Update the terraform configuration in main.tf for your list of GitHub repos 

### Create infra
Assumption here is that all environment have separate AWS accounts
- `export environment=dev`
- `terraform init -backend-config=environments/${environment}/backend.tf`
- `terraform apply --var-file=environments/${environment}/${environment}.tfvars`

### Destroy infra
- `terraform apply -destroy -var-file=environments/${environment}/${environment}.tfvars`

### Reference
- [Use IAM roles to connect GitHub Actions to actions in AWS](https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/)
- [Configuring OpenID Connect in Amazon Web Services](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
