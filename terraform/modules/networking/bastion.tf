resource "aws_instance" "bastion" {
  ami                         = var.ec2_iam
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.public["1a"].id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  key_name                    = var.key_pair_name

  tags = {
    Name = "Bastion Host"
  }
}