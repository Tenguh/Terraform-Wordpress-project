# creating security group
resource "aws_security_group" "ec2_sg" {
    name = "ec2_sg"
  description = "Allow  traffic for ssh"
  vpc_id = var.vpc_id


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
    description = "allowing traffic from everywhere"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow http traffic"
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

#creating the instance
resource "aws_instance" "wordpress" {
  ami                    = "ami-0b0dcb5067f052a63"
  instance_type          = "t3.small"
  key_name               = "harriet-key"
  user_data              = templatefile("scripts/userdata.sh", { mount_script = file("scripts/mounttarget.sh") })

  subnet_id = var.subnet_id
  security_groups = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  
   
  tags = {
    Name = "WP-instance"
  }
}


  
    