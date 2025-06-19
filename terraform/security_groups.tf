resource "aws_security_group" "nat" {
  name        = "nat-instance-sg"
  description = "Allow NAT traffic from private subnets"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_subnet.private_1a.cidr_block, aws_subnet.private_1b.cidr_block]
  }
}