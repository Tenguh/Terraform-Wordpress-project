variable "ami_id" {
  description = "AMI ID for instances"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "db_endpoint" {
  description = "RDS endpoint URL"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "key_pair_name" {
  description = "ec2 key name"
  type        = string
}

variable "ec2_sg_id" {
  type = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the ASG"
}

variable "target_group_arns" {
  type        = list(string)
  description = "List of Target Group ARNs for the Auto Scaling Group"
}

variable "vpc_id" {}