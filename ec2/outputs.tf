output "instance_id" {
  value = aws_instance.wordpress.id
}

output "instance_public_ip" {
  value = aws_instance.wordpress.public_ip
}

output "ec2_sg_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.ec2_sg.id
}

output "latest_amazon_linux_image" {
  description = "ID of the latest Amazon Linux 2 AMI"
  value       = data.aws_ami.latest_amazon_linux_image.id
}