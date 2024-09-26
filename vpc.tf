// Create VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "TerraformVPC"
  }
}

// Create Public Subnets 
resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnets_cidr)
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.public_subnets_cidr[count.index]
  availability_zone = var.availabililty_zone_1[count.index]
  map_public_ip_on_launch = true 

  tags = {
    Name = var.public_subnet_names[count.index]
  }
}

// create private subnet 
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.private_cidr
  availability_zone = var.availablilty_zone
  map_public_ip_on_launch = false 

  tags = {
    Name = "private_subnet"
  }
}

// create internet gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "internet_gateway"
  }
}

// Create Route Table for public subnets
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name = "route_table"
  }
}

// associate route table with public subnets
resource "aws_route_table_association" "rta" {
  count = length(var.public_subnets_cidr)
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.rt.id 
}