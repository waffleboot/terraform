
// https://learn.hashicorp.com/terraform/getting-started/build#configuration

provider "aws" {
  profile = "default"
  region  = "eu-north-1"
}

resource "aws_vpc" "test" {
  cidr_block           = "192.168.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "test"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.test.id
  cidr_block              = "192.168.0.0/26"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.test.id
  cidr_block              = "192.168.0.64/26"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "private"
  }
}

resource "aws_internet_gateway" "test" {
  vpc_id = aws_vpc.test.id
  tags = {
    Name = "test"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.test.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test.id
  }
  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.test.id
  tags = {
    Name = "private"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.test.id
  name   = "allow_ssh"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
  }
  tags = {
    Name = "allow_ssh"
  }
}

data "aws_security_groups" "default" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.test.id]
  }
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

resource "aws_instance" "front" {
  ami                    = "ami-0662eb9b9b8685935"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = concat([aws_security_group.allow_ssh.id], data.aws_security_groups.default.ids)
  key_name               = "ssh-key"
  tags = {
    Name = "front"
  }
}

resource "aws_instance" "back" {
  ami                    = "ami-0662eb9b9b8685935"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = data.aws_security_groups.default.ids
  key_name               = "ssh-key"
  tags = {
    Name = "back"
  }
}

resource "aws_network_interface" "private" {
  subnet_id       = aws_subnet.private.id
  security_groups = data.aws_security_groups.default.ids
  attachment {
    instance     = aws_instance.front.id
    device_index = 1
  }
  tags = {
    Name = "test"
  }
}
