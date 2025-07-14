provider "aws" {
  region = var.region
}

data "aws_availability_zones" "az" {}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags       = { Name = "main-vpc" }
}

resource "aws_subnet" "private" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.az.names[count.index]
  map_public_ip_on_launch = false
  tags = { Name = "private-${count.index + 1}" }
}

resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group"
  subnet_ids = aws_subnet.private[*].id
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow MySQL from VPC"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "rds" {
  identifier                   = "my-rds"
  engine                       = "mysql"
  engine_version               = "8.0"
  instance_class               = var.instance_class
  allocated_storage            = 20
  db_name                      = var.db_name
  username                     = var.db_username

  # Enable AWS Secrets Manager to manage & rotate credentials
  manage_master_user_password = true

  db_subnet_group_name        = aws_db_subnet_group.rds.name
  vpc_security_group_ids      = [aws_security_group.rds_sg.id]
  publicly_accessible         = false
  skip_final_snapshot         = true
  deletion_protection         = false
}
