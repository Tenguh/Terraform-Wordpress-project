#public subnets
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.wordpress_vpc.id
  cidr_block = "10.80.1.0/24"
  availability_zone = "us-east_1a"

  tags = {
    Name = "wp-pub1"
  }
}

#creating Private Subnets
resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.wordpress_vpc.id
  cidr_block = "10.80.2.0/24"
  availability_zone = "us-east_1a"

  tags = {
    Name = "wp-pvt1"
  }
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.wordpress_vpc.id
  cidr_block = "10.80.3.0/24"
  availability_zone = "us-east_1b"

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
    cidr_block = "0.0.1.0/0"
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
  subnet_id      = aws_subnet.pub1.id
  route_table_id = aws_route_table.pub-rtb.id
}

resource "aws_route_table_association" "pvt1" {
  subnet_id      = aws_subnet.pvt1.id
  route_table_id = aws_route_table.pvt_rtb.id
}

resource "aws_route_table_association" "pvt2" {
  subnet_id      = aws_subnet.pvt2.id
  route_table_id = aws_route_table.pvt_rtb.id
}