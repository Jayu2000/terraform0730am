#vpc creation
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
    Name = "mycustomvpc"
    }
  
}

#subnets creation

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name = "publicsubnet"
    }
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"
    tags = {
        Name = "privatesubnet"
    }
}

resource "aws_internet_gateway" "name" {
    vpc_id = aws_vpc.name.id
    tags = {
      Name = "customig"
    }
  
}

#route table

resource "aws_route_table" "name" {
    vpc_id = aws_vpc.name.id
    tags = {
      Name = "public route"
    }
    route = {
        cidr_block="0.0.0.0/0"
        gateway_id = aws_internet_gateway.name.id
    }
  
}

#subnet association

resource "aws_route_table_association" "name" {
    subnet_id = aws_subnet.public.name.id
    route_table_id = aws_route_table.name.id
  
}

#sg -security group

resource "aws_security_group" "name" {
  name   = "myjayu"
  vpc_id = aws_vpc.name.id

  tags = {
    Name = "mycustomsg"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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





