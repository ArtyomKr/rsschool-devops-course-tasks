resource "aws_instance" "k3s_server" {
  ami                    = var.ec2_iam
  instance_type          = var.ec2_instance_type
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.k3s.id]
  key_name               = var.instance_key_pair_name

  user_data = <<-EOF
    #!/bin/bash
    curl -sfL https://get.k3s.io | sh -s - server \
      --cluster-init \
      --token=${random_password.k3s_token.result} \
      --bind-address=${aws_instance.k3s_server.private_ip} \
      --advertise-address=${aws_instance.k3s_server.private_ip}
  EOF

  tags = {
    Name = "k3s-server"
  }
}