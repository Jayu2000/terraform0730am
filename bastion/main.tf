provider "aws" {


}

resource "aws_vpc" "mycustomvpc" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "mycustomvpc"
  }

}

resource "aws_subnet" "publicsubnet" {
  vpc_id                  = aws_vpc.mycustomvpc.id
  cidr_block              = "10.0.0.0/25"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "publicsubnet"
  }

}

resource "aws_subnet" "privatesubnet" {
  vpc_id            = aws_vpc.mycustomvpc.id
  cidr_block        = "10.0.0.128/25"
  availability_zone = "us-east-1b"
  tags = {
    Name = "privatesubnet"
  }

}
#public route table
resource "aws_route_table" "publicroutetable" {
  vpc_id = aws_vpc.mycustomvpc.id
  tags = {
    Name = "publicroutetable"
  }

}

resource "aws_route_table_association" "publicassociation" {
  route_table_id = aws_route_table.publicroutetable.id
  subnet_id      = aws_subnet.publicsubnet.id

}

#private route table
resource "aws_route_table" "privateroute" {
  vpc_id = aws_vpc.mycustomvpc.id
  tags = {
    Name = "privateroute"
  }

}

resource "aws_route_table_association" "privateassociation" {
  route_table_id = aws_route_table.privateroute.id
  subnet_id      = aws_subnet.privatesubnet.id

}

resource "aws_internet_gateway" "myig" {
  vpc_id = aws_vpc.mycustomvpc.id
  tags = {
    Name = "myig"
  }

}
#edit route -only public -attached internet gateway
resource "aws_route" "editroutepub" {
  route_table_id         = aws_route_table.publicroutetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.myig.id

}

resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.mycustomvpc.id
  name   = "sg"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg"
  }
}


resource "aws_instance" "publicinstance" {
  ami             = "ami-0cbbe2c6a1bb2ad63"
  subnet_id       = aws_subnet.publicsubnet.id
  instance_type   = "t2.micro"
  key_name        = "project"
  user_data       = file("shell.sh")
  security_groups = [aws_security_group.sg.id]
  tags = {
    Name = "publicinstance"
  }

}

resource "aws_instance" "privateinstance" {
  ami             = "ami-0cbbe2c6a1bb2ad63"
  subnet_id       = aws_subnet.privatesubnet.id
  instance_type   = "t2.micro"
  key_name        = "project"
  security_groups = [aws_security_group.sg.id]
  tags = {
    Name = "privateinstance"
  }

}