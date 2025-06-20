resource "aws_instance" "bastion" {
  ami                         = var.ec2_iam
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_1a.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.bastion.id]

  tags = {
    Name = "Bastion-Host"
  }
}