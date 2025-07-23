terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "My_VPC" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "My_VPC"
  }
}

# Public Subnet
resource "aws_subnet" "Public_Subnet" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public_Subnet"
  }
}

# Private Subnet
resource "aws_subnet" "Private_Subnet" {
  vpc_id            = aws_vpc.My_VPC.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Private_Subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "My_IG" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
    Name = "My_IG"
  }
}

# EIP for NAT
resource "aws_eip" "IP" {
  domain = "vpc"
  tags = {
    Name = "My_EIP"
  }
}

# NAT Gateway in Public Subnet
resource "aws_nat_gateway" "My_NAT" {
  allocation_id = aws_eip.IP.id
  subnet_id     = aws_subnet.Public_Subnet.id
  tags = {
    Name = "My_NAT"
  }

  depends_on = [aws_internet_gateway.My_IG]
}

# Public Route Table
resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.My_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.My_IG.id
  }

  tags = {
    Name = "Public-RT"
  }
}

# Associate Public RT with Public Subnet
resource "aws_route_table_association" "Public_RT_ASSO" {
  route_table_id = aws_route_table.Public_RT.id
  subnet_id      = aws_subnet.Public_Subnet.id
}

# Private Route Table (for NAT)
resource "aws_route_table" "Private_RT" {
  vpc_id = aws_vpc.My_VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.My_NAT.id
  }

  tags = {
    Name = "Private-RT"
  }
}

# Associate Private RT with Private Subnet
resource "aws_route_table_association" "Private_RT_ASSO" {
  route_table_id = aws_route_table.Private_RT.id
  subnet_id      = aws_subnet.Private_Subnet.id
}

# Security Group
resource "aws_security_group" "My_SG" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
    Name = "My_SG"
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

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance in Private Subnet
resource "aws_instance" "My_EC2" {
  ami                    = "ami-071647d7c4a87cb3a"  # Amazon Linux 2 AMI in us-east-1
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.Private_Subnet.id
  vpc_security_group_ids = [aws_security_group.My_SG.id]

  tags = {
    Name = "My_Private_EC2"
  }
}
