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


# Terraform AWS k3s cluster setup

This Terraform configuration sets up a k3s cluster using AWS infrastructure.

It consists of 1 server and 2 (you can change their number in variables) agents.

## Resources Created

### 1. K3s server

### 2. K3s agents (2)

### 3. Security group for k3s cluster

## Usage locally

1. Clone the repository.
2. `cd` into `/terraform` folder.
3. Run `terraform init`.
4. Make changes to terraform configuration.
5. Run `terraform apply`
6. Connect with ssh to bastion host, use ssh agent to forward the k3s server key.
7. Connect to k3s server to run `kubectl` commands.