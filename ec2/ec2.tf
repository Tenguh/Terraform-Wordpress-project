# creating security group
resource "aws_security_group" "ec2_sg" {
    name = "ec2_sg"
  description = "Allow  traffic for ssh"
  vpc_id = var.vpc_id

#ssh traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
    description = "allowing traffic from everywhere"
  }

#http traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow http traffic"
  }

  #https traffic
ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
 
} 
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]

  }
}

#creating the instance
resource "aws_instance" "wordpress" {
  ami                    = data.aws_ami.latest-amazon-linux-image.id
  instance_type          = "t3.small"
  key_name               = "harriet-key"
  user_data = templatefile("scripts/userdata.sh", { 
  endpoint      = var.db_endpoint,
  mount_script = file("scripts/mounttarget.sh")
})

  subnet_id = var.subnet_id
  security_groups = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "WP-instance"
  }
}


  
    