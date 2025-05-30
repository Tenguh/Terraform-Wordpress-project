output "private1_subnet_id" {
    value = aws_subnet.private1.id
    description = "outing the private subnet id" 
}
output "private2_subnet_id" {
    value = aws_subnet.private2.id
    description = "outputing the private subnet id"
}

output "public1_subnet_id" {
    value = aws_subnet.public1.id
    description = "outing the public subnet id"
}

output "vpc_id" {
  value = aws_vpc.wordpress_vpc.id
}

output "private_subnet_ids" {
  value = [aws_subnet.private1.id, aws_subnet.private2.id] 

}

output "public_subnet_ids" {
  value = [aws_subnet.public1.id, aws_subnet.public2.id]
}



