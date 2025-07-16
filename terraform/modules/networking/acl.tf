resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = [aws_subnet.private_1a.id, aws_subnet.private_1b.id]

  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
    rule_no    = 100
  }

  ingress {
    rule_no    = 90
    from_port  = 32768
    to_port    = 60999
    protocol   = "tcp"
    cidr_block = "0.0.0.0/0"
    action     = "allow"
  }

  ingress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_block = aws_vpc.main.cidr_block
    action     = "allow"
    rule_no    = 100
  }

  tags = {
    Name = "Private-Instance-ACL"
  }
}