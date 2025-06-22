variable "allowed_access_ips" {
  type = list(string)
}

variable "ec2_iam" {
  type = string
}

variable "key_pair_name" {
  type    = string
  default = "Private-key-tyoma"
}

variable "aws_region" {
  type = string
}

variable "ec2_instance_type" {
  type = string
}

