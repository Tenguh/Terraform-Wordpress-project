# module code to create the ec2 instance with user data
module "ec2" {
  source        = "./ec2"
  key_pair_name = var.key_pair_name
  vpc_id        = module.subnet.vpc_id
  subnet_id     = module.subnet.public1_subnet_id
}

module "subnet" {
  source                     = "./subnet"
  private1_cidr_block        = var.private1_cidr_block
  private2_cidr_block        = var.private2_cidr_block
  public1_cidr_block         = var.public1_cidr_block
  private1_availability_zone = var.private1_availability_zone
  private2_availability_zone = var.private2_availability_zone
  public1_availability_zone  = var.public1_availability_zone
  vpc_cidr_block             = var.vpc_cidr_block

}

module "database" {
  source         = "./database"
  password       = var.password
  instance_class = var.instance_class
  #subnet_ids = [module.subnet.public1_subnet_id, module.subnet.private1_subnet_id]
  private1_subnet_id  = module.subnet.private1_subnet_id
  private2_subnet_id = module.subnet.private2_subnet_id
  public1_subnet_id = module.subnet.public1_subnet_id
}

