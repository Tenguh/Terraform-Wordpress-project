output "security_group_id" {
  value       = aws_security_group.rds_sg.id
}
output "db_instance_endpoint" {
  value       = aws_db_instance.myinstance.endpoint
}

output "public1_subnet_id" {
  value = var.public1_subnet_id
}

output "private1_subnet_id" {
  value = var.private1_subnet_id
}


