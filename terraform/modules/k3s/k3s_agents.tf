resource "aws_instance" "k3s_agent" {
  count                  = var.k3s_agent_count
  ami                    = var.ec2_iam
  instance_type          = var.ec2_instance_type
  subnet_id              = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  vpc_security_group_ids = [aws_security_group.k3s.id]
  key_name               = var.instance_key_pair_name

  user_data = <<-EOF
    #!/bin/bash
    curl -sfL https://get.k3s.io | sh -s - agent \
      --token=${random_password.k3s_token.result} \
      --server=https://${aws_instance.k3s_server.private_ip}:6443
  EOF

  tags = {
    Name = "k3s-agent-${count.index}"
  }

  depends_on = [aws_instance.k3s_server]
}