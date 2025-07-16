variable "access_ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "ec2_iam" {
  type    = string
  default = "ami-092ff8e60e2d51e19"
}

variable "key_pair_name" {
  type    = string
  default = "Private-key-tyoma"
}

