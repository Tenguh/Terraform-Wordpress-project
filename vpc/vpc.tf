resource "aws_vpc" "wordpress_vpc" {
  cidr_block       = "10.88.0.0/16"

  tags = {
    Name = "wp-vpc"
  }
}