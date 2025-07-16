variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "bastion_sg_id" {
  description = "ID of the bastion security group"
  type        = string
}

variable "instance_key_pair_name" {
  type = string
}

variable "ec2_iam" {
  type = string
}

variable "ec2_instance_type" {
  type = string
}

variable "k3s_agent_count" {
  type    = number
  default = 2
}