resource "aws_instance" "proxy_server" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.proxy_subnet.id
  vpc_security_group_ids = [aws_security_group.proxy_sg.id]

  key_name = "tmp-mac"

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = "0.006"
    }
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y squid
              mv /etc/squid/squid.conf /etc/squid/squid.conf.backup
              echo "
              http_access allow all
              http_port 3128
              cache deny all
              acl localnet src 10.0.0.0/8 # RFC1918 possible internal network
              acl localnet src 172.16.0.0/12  # RFC1918 possible internal network
              acl localnet src 192.168.0.0/16 # RFC1918 possible internal network
              acl localnet src fc00::/7       # RFC 4193 local private network range
              acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines
              acl SSL_ports port 443
              acl Safe_ports port 80          # http
              acl Safe_ports port 21          # ftp
              acl Safe_ports port 443         # https
              acl Safe_ports port 70          # gopher
              acl Safe_ports port 210         # wais
              acl Safe_ports port 1025-65535  # unregistered ports
              acl Safe_ports port 280         # http-mgmt
              acl Safe_ports port 488         # gss-http
              acl Safe_ports port 591         # filemaker
              acl Safe_ports port 777         # multiling http
              acl CONNECT method CONNECT
              http_access deny !Safe_ports
              http_access deny CONNECT !SSL_ports
              http_access allow localhost manager
              http_access deny manager
              http_access allow localhost
              " > /etc/squid/squid.conf
              systemctl enable squid
              systemctl start squid
              EOF

  tags = {
    Name = "ProxyServer"
  }
}
