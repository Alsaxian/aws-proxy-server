resource "aws_security_group" "proxy_sg" {
  name        = "proxy_sg"
  description = "Allow web traffic to proxy server"
  vpc_id      = aws_vpc.proxy_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
    description = "SSH Access"
  }

  ingress {
    from_port   = 3128
    to_port     = 3128
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
    description = "Squid Proxy Access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
