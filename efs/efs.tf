#creating efs file system
resource "aws_efs_file_system" "efs" {
  creation_token   = "wp-efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"

  tags = {
    Name = "wp-EFS"
  }
}

#creating efs mount target
resource "aws_efs_mount_target" "efs_mt" {
  count           = length(var.subnet_ids)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [aws_security_group.efs_sg.id]
}

#security group for efs
resource "aws_security_group" "efs_sg" {
  name        = "efs-sg"
  description = "Allow NFS traffic for EFS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.80.0.0/16"]  # Adjust this to your VPC CIDR
  }

  tags = {
    Name = "EFS-SG"
  }
}




