# Terraform AWS Infrastructure for GitHub Actions

This Terraform configuration sets up AWS infrastructure to enable GitHub Actions workflows to interact with AWS services securely using OpenID Connect (OIDC) for authentication.

The IAM role and S3 Bucket for terraform state should be created **before** running GitHub actions. The creation of S3 bucket for terraform state was separated into dedicated folder to prevent a chicken-egg situation.

## Resources Created

### 1. OIDC Provider for GitHub Actions
- **Resource Type**: `aws_iam_openid_connect_provider`
- **Name**: `github_actions`

### 2. IAM Role for GitHub Actions
- **Resource Type**: `aws_iam_role`
- **Name**: `GithubActionsRole`
- **Permissions**:
    - Allows GitHub Actions from specific repository/branches to assume the role
    - Attached managed policies:
        - AmazonEC2FullAccess
        - AmazonEventBridgeFullAccess
        - AmazonRoute53FullAccess
        - AmazonS3FullAccess
        - AmazonSQSFullAccess
        - AmazonVPCFullAccess
        - IAMFullAccess
- **Trust Policy**:
    - Allows `sts:AssumeRoleWithWebIdentity` from GitHub Actions OIDC provider
    - Restricted to:
        - Repository: `ArtyomKr/rsschool-devops-course-tasks`
        - Branches: `main` and pull requests

### 3. S3 Bucket for Terraform State
- **Resource Type**: `aws_s3_bucket`
- **Name**: `artyomkr-terraform-state`
- **Features**:
    - Versioning enabled
    - Server-side encryption (AES256)
    - Private access (all public access blocked)
    - Located in `eu-central-1` region

## Usage locally

1. Clone the repository.
2. `cd` into `/terraform` folder.
3. Run `terraform init`.
4. Make changes to terraform configuration.
5. Run `terraform apply` (make sure the backend bucket is created, you can use terraform config in `/backend` folder to create it)

## Usage in GitHub Actions

To use a **GithubActionsRole** role in GitHub Actions workflows:

```yaml
jobs:
  deploy:
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: aws-actions/configure-aws-credentials@v2
        with:
          role-to-assume: arn:aws:iam::049886442714:role/GithubActionsRole
          aws-region: eu-central-1
```