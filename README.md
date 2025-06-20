# Terraform AWS Infrastructure for GitHub Actions

This Terraform configuration sets up AWS infrastructure to enable GitHub Actions workflows to interact with AWS services securely using OpenID Connect (OIDC) for authentication.

The IAM role and S3 Bucket for terraform state should be created **before** running GitHub actions. The creation of S3 bucket for terraform state was separated into dedicated folder to prevent a chicken-egg situation.

## Resources Created

### 1. AWS VPC

### 2. Subnets
- Private and public subnets were created in different AZs

### 3. Internet gateway and routing table

### 4. Nat and bastion instance

### 5. Security groups and ACL
- Security groups were implemented for nat and bastion instances, ACL for private subnet

## Usage locally

1. Clone the repository.
2. `cd` into `/terraform` folder.
3. Run `terraform init`.
4. Make changes to terraform configuration.
5. Run `terraform apply`