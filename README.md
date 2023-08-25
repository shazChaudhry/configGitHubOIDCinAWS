Terraform configuration files in this repo will configure GtHub OpenID Connect (_OIDC_) in AWS. This would be prerequisite to running your project specific GitHub workflows with Terraform

These resources are created in AWS by executing Terraform on a command-line. Ensure the resultant satefiles are version controlled for future maintenance

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
