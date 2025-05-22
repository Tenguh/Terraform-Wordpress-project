# Network Configuration
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string

}

variable "public1_cidr_block" {
  description = "CIDR block for public subnet 1"
  type        = string

}

variable "private1_cidr_block" {
  description = "CIDR block for private subnet 1"
  type        = string
}

variable "private2_cidr_block" {
  description = "CIDR block for private subnet 2"
  type        = string

}

variable "public1_availability_zone" {
  description = "AZ for public subnet 1"
  type        = string
}

variable "private1_availability_zone" {
  description = "AZ for private subnet 1"
  type        = string
}

variable "private2_availability_zone" {
  description = "AZ for private subnet 2"
  type        = string
}

# Database Configuration
variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
}

# EC2 Configuration
variable "key_pair_name" {
  description = "Name for new key pair (if creating)"
  type        = string

}

variable "db_endpoint" {
  description = "RDS endpoint URL"
  type        = string
}
variable "db_user" {
  description = "database user name"
  type = string
}