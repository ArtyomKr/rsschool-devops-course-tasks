locals {
  public_subnets = {
    "1a" = { cidr = "10.0.0.0/24", az = "${var.aws_region}a" },
    "1b" = { cidr = "10.0.1.0/24", az = "${var.aws_region}b" }
  }
  private_subnets = {
    "1a" = { cidr = "10.0.2.0/24", az = "${var.aws_region}a" },
    "1b" = { cidr = "10.0.3.0/24", az = "${var.aws_region}b" }
  }
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${each.key}"
  }
}

resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "Private Subnet ${each.key}"
  }
}
