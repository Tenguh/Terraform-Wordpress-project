 variable "public1_cidr_block"{}
 variable "public2_cidr_block" {}
 variable "private1_cidr_block"{}
 variable "private2_cidr_block"{}
 variable "private1_availability_zone" {}
 variable "private2_availability_zone" {}
 variable "public1_availability_zone" {}
 
 variable "vpc_cidr_block" {
    type = string
    description = "vpc cidr block to use"
  
}

 