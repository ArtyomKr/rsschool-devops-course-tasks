resource "aws_instance" "k3s_agent" {
  count         = var.k3s_agent_count
  ami           = var.ec2_iam
  instance_type = var.ec2_instance_type
  subnet_id     = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  vpc_security_group_ids = [aws_security_group.k3s.id]
  # key_name      = var.ssh_key_name
  iam_instance_profile = var.ec2_iam

  user_data = <<-EOF
    #!/bin/bash
    TOKEN=$(aws ssm get-parameter --name /k3s/cluster-token --with-decryption --query Parameter.Value --output text)
    curl -sfL https://get.k3s.io | K3S_URL=https://${aws_instance.k3s_server.private_ip}:6443 K3S_TOKEN=$${TOKEN} sh -
  EOF

  tags = {
    Name = "k3s-agent-${count.index}"
  }

  depends_on = [aws_instance.k3s_server]
}