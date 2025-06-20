resource "aws_instance" "nat" {
  ami           = "ami-092ff8e60e2d51e19"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_1a.id
  associate_public_ip_address = true
  source_dest_check = false

  user_data = <<-EOF
    #!/bin/bash
    sudo sysctl -w net.ipv4.ip_forward=1
    sudo iptables -t nat -A POSTROUTING -o ens5 -s 0.0.0.0/0 -j MASQUERADE
  EOF

  tags = {
    Name = "NAT-Instance"
  }
}

resource "aws_eip" "nat" {
  instance = aws_instance.nat.id
  # domain   = "vpc"
}