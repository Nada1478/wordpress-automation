resource "aws_vpc" "automated" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "automated"
  }
}

resource "aws_subnet" "publicsubnet1" {
  vpc_id                  = aws_vpc.automated.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "privatesubnet" {
  vpc_id            = aws_vpc.automated.id
  cidr_block        = var.privatesubnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.automated.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.automated.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.publicsubnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "security1" {
  name        = "security1"
  description = "practice security group"
  vpc_id      = aws_vpc.automated.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sec"
  }
}


resource "aws_instance" "server1" {
  ami           = var.ec2_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.publicsubnet1.id
  key_name     = var.key1
  

  vpc_security_group_ids = [aws_security_group.security1.id]

  tags = {
    Name = "server1"
  }
}
