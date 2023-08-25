Terraform configuration files in this repo will configure GtHub OpenID Connect (_OIDC_) in AWS. This would be prerequisite to running your project specific GitHub workflows with Terraform

These resources are created in AWS by executing Terraform on a command-line. Ensure the resultant satefiles are version controlled for future maintenance

The following is going to be created in AWS
- Region is set to be eu-west-2 (London). Change the variable for a different region
- An IAM identity provider for GitHub OIDC
- An IAM role which can be assumed by trusted resources using OpenID Connect Federated Users. Update the terraform configuration in main.tf for your list of GitHub repos 
- An S3 bucket where GH actions will save terraform states for a given environment like dev
- A DynamoDB table that is to be used for locking TF runs for a given environment; S3 backend

### Create infra
Assumption here is that all environment have separate AWS accounts
- `export environment=dev`
- `terraform init -backend-config=environments/${environment}/backend.tf`
- `terraform apply --var-file=environments/${environment}/${environment}.tfvars`
- Files generated under `statefiles` directory will need to be version controlled for future maintenance

### Destroy infra
- `terraform apply -destroy -var-file=environments/${environment}/${environment}.tfvars`
- Files modified under `statefiles` directory will need to be version controlled for future maintenance

### Reference
- [Use IAM roles to connect GitHub Actions to actions in AWS](https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/)
- [Configuring OpenID Connect in Amazon Web Services](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
