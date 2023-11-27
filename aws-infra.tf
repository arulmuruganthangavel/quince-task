# main.tf

provider "aws" {
  region = "ap-south-1"
}

# VPC
resource "aws_vpc" "quince_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Public Subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.quince_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.quince_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

# Private Subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.quince_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-south-1b"
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.quince_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-south-1b"
}

# NAT Gateway
resource "aws_nat_gateway" "quince_nat" {
  allocation_id = aws_instance.my_ec2_instance.id
  subnet_id     = aws_subnet.public_subnet_1.id
}

# S3 Bucket
resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "quince-task"
  acl    = "private"
}

# IAM Role
resource "aws_iam_role" "my_iam_role" {
  name = "quince-iam-role"
  
  # Assume role policy document - replace with your actual policy
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Security Group
resource "aws_security_group" "my_security_group" {
  name        = "quince-sg"
  description = "custom_sg"
  
  # Define your security group rules here
}

# EC2 Instance
resource "aws_instance" "my_ec2_instance" {
  ami             = "your_ami_id"
  instance_type   = "t4g.micro"
  subnet_id       = aws_subnet.private_subnet_1.id
  security_group  = [aws_security_group.my_security_group.id]
  iam_instance_profile = aws_iam_instance_profile.my_instance_profile.name
  
  # Define your EC2 instance configuration here
}
