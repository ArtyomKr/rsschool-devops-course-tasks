resource "aws_instance" "nat" {
  ami                         = var.ec2_iam
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.public["1a"].id
  associate_public_ip_address = true
  source_dest_check           = false
  vpc_security_group_ids      = [aws_security_group.nat.id]
  key_name                    = var.key_pair_name


  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y iptables iproute
    echo "net.ipv4.ip_forward = 1" | tee -a /etc/sysctl.conf
    sysctl -p
    iptables -t nat -A POSTROUTING -o enX0 -s 0.0.0.0/0 -j MASQUERADE
    /sbin/iptables-save | tee /etc/sysconfig/iptables
  EOF

  tags = {
    Name = "NAT Instance"
  }
}

resource "aws_eip" "nat" {
  instance = aws_instance.nat.id
}