resource "aws_vpc" "proxy_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "ProxyVPC"
  }
}

resource "aws_subnet" "proxy_subnet" {
  vpc_id                  = aws_vpc.proxy_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "ProxySubnet"
  }
}

resource "aws_internet_gateway" "proxy_igw" {
  vpc_id = aws_vpc.proxy_vpc.id
  tags = {
    Name = "ProxyIGW"
  }
}

resource "aws_route_table" "proxy_route_table" {
  vpc_id = aws_vpc.proxy_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.proxy_igw.id
  }

  tags = {
    Name = "ProxyRouteTable"
  }
}

resource "aws_route_table_association" "proxy_rta" {
  subnet_id      = aws_subnet.proxy_subnet.id
  route_table_id = aws_route_table.proxy_route_table.id
}
