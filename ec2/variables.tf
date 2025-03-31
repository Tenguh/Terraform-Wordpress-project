variable "key_pair_name" {
  type        = string
  description = "keypair to utilize"
}

variable "db_endpoint" {
  type        = string
  description = "Database endpoint for WordPress"
}

variable "vpc_id" {}
variable "subnet_id" {}



