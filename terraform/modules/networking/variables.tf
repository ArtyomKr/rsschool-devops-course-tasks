variable "allowed_access_ips" {
  type = list(string)
}

variable "ec2_iam" {
  type = string
}

variable "bastion_key_pair_name" {
  type = string
}

variable "instance_key_pair_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "ec2_instance_type" {
  type = string
}

