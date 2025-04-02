resource "aws_vpc" "wordpress_vpc" {
  cidr_block       = var.vpc_cidr_block

  tags = {
    Name = "wp-vpc"
  }
}

#public subnet
resource "aws_subnet" "public1" {    
  vpc_id     = aws_vpc.wordpress_vpc.id
  cidr_block = var.public1_cidr_block
  availability_zone = var.public1_availability_zone
  map_public_ip_on_launch = false 

  tags = {
    Name = "wp-pub1"
  }
}

#creating Private Subnets
resource "aws_subnet" "private1" { 
  vpc_id     = aws_vpc.wordpress_vpc.id
  cidr_block = var.private1_cidr_block
  availability_zone = var.private1_availability_zone

  tags = {
    Name = "wp-pvt1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.wordpress_vpc.id
  cidr_block = var.private2_cidr_block
  availability_zone = var.private2_availability_zone

  tags = {
    Name = "wp-pvt2"
  }
}

#internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.wordpress_vpc.id

  tags = {
    Name = "wp-igw"
  }
}
#elastic ip
resource "aws_eip" "eip" {
  domain = "vpc"
}

#creating Nat
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "wp-nat"
  }
}

#public rtb
resource "aws_route_table" "pub-rtb" {
  vpc_id = aws_vpc.wordpress_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "pub-rtb"
  }
}


#private rtb
resource "aws_route_table" "pvt_rtb" {
  vpc_id = aws_vpc.wordpress_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "pvt-rtb"
  }
}

#route table association
resource "aws_route_table_association" "pub1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.pub-rtb.id
}

resource "aws_route_table_association" "pvt1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.pvt_rtb.id
}

resource "aws_route_table_association" "pvt2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.pvt_rtb.id
}