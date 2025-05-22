resource "aws_lb_target_group" "wordpress" {
  name     = "wordpress-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.subnet.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

# module code to create the ec2 instance with user data
module "ec2" {
  source        = "./ec2"
  key_pair_name = var.key_pair_name
  vpc_id        = module.subnet.vpc_id
  subnet_id     = module.subnet.public1_subnet_id
  db_endpoint   = module.database.db_endpoint
}

module "subnet" {
  source                     = "./subnet"
  private1_cidr_block        = var.private1_cidr_block
  private2_cidr_block        = var.private2_cidr_block
  public1_cidr_block         = var.public1_cidr_block
  public2_cidr_block         = var.public2_cidr_block
  private1_availability_zone = var.private1_availability_zone
  private2_availability_zone = var.private2_availability_zone
  public1_availability_zone  = var.public1_availability_zone
  vpc_cidr_block             = var.vpc_cidr_block

}

module "database" {
  source             = "./database"
  password           = var.password
  instance_class     = var.instance_class
  private1_subnet_id = module.subnet.private1_subnet_id
  private2_subnet_id = module.subnet.private2_subnet_id
  public1_subnet_id  = module.subnet.public1_subnet_id
  db_name            = var.db_name

}

module "efs" {
  source     = "./efs"
  vpc_id     = module.subnet.vpc_id
  subnet_ids = module.subnet.private_subnet_ids
}


module "asg" {
  source             = "./asg"
  key_pair_name      = var.key_pair_name
  db_name            = var.db_name
  password           = var.password
  security_group_ids = [module.ec2.ec2_sg_id]
  ami_id             = module.ec2.latest_amazon_linux_image_id
  db_endpoint        = module.database.db_endpoint
  key_name           = var.key_pair_name
  db_user            = var.db_user
  ec2_sg_id          = module.ec2.ec2_sg_id
  subnet_ids         = module.subnet.public_subnet_ids
  vpc_id             = module.subnet.vpc_id
  target_group_arns  = [aws_lb_target_group.wordpress.arn] #module.asg.wordpress_arn]
}

