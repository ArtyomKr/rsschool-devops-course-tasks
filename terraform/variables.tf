variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "github_repository" {
  type    = string
  default = "ArtyomKr/rsschool-devops-course-tasks"
}

variable "aws_account_id" {
  type    = string
  default = "049886442714"
}

variable "ec2_iam" {
  type    = string
  default = "ami-092ff8e60e2d51e19"
}

variable "ec2_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "allowed_access_ips" {
  description = "CIDR blocks allowed to SSH to bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "bastion_key_pair_name" {
  type    = string
  default = "Bastion_key_pair"
}

variable "instance_key_pair_name" {
  type    = string
  default = "Instance_key_pair"
}

variable "git_actions_policies" {
  type = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
    "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
  ]
}
