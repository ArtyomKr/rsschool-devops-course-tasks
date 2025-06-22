resource "aws_instance" "k3s_server" {
  ami           = var.ec2_iam
  instance_type = var.ec2_instance_type
  subnet_id     = var.private_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.k3s.id]
  # key_name      = var.ssh_key_name <-- Need to properly set up bastion access keys

  user_data = <<-EOF
    curl -sfL https://get.k3s.io | sh -s - server --cluster-init
  EOF

  tags = {
    Name = "k3s-server"
  }
}