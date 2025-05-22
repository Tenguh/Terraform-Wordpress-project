***Automating WordPress Deployment on AWS using Terraform Modules***




  ![Architecture](<ReadmeImages/_Architecture Diagram.png>)
## Overview 
 A small marketing agency needs a **highly available, scalable, and low-maintenance** WordPress hosting solution. Their manual setup on a single EC2 instance led to:  
 - **Downtime** during traffic spikes.  
 - **No disaster recovery** (data loss risk).  
 - **Time-consuming manual scaling.**  
 
  **My Solution:**  
  Automate the deployment using **Terraform (IaC)** and AWS services, ensuring:  
    1. **Infrastructure as Code (Terraform):**  
    - Automated creation of **EC2, EFS, Security Groups, and VPC** components which can be repeatedly deployed across environments. 
 
    2. **High Availability & Scalability:**  
    - **EFS (Elastic File System):** Decoupled storage from EC2, allowing multiple instances to share WordPress files.  
    - **User Data Scripts:** Automated installation of WordPress, PHP, and EFS utilities on EC2 launch.  
 
    3. **Cost Optimization:**   
    - Auto-scaling rules to handle traffic spikes.  
 
   ### **AWS Services Used:**    
   
   - **EC2**: Host WordPress with automated setup via user data.  
   - **EFS**: Shared storage for WordPress (uploads/themes). 
   - **VPC**: Isolated network environment. 
   - **Security Groups**: Restricted access to HTTP/SSH. 
   - **Terraform**: Infrastructure as Code (IaC) for reproducibility. 
 
   ### **Deployment Process**

    This project will guide you through setting up a WordPress server on EC2 instance using terraform modules to create the various AWS services. WordPress is installed on the ec2 instance with the help of userdata script that Install PHP and WordPress. Also EFS utilities are installed and configured on the ec2 instance using a userdata script.  
  

  ## Prerequisites
  * AWS Account: Admin access to AWS account
  * AWS CLI: Installed and configured with the right credentials
  * Git: [Install git using this link](https://git-scm.com/downloads/win)
  * Terraform: [Install terraform using this link](https://developer.hashicorp.com/terraform/install)
  * Install Visual Studio Code with the neccesary extensions.
 

1) [Link to  GitHub hosting the project files](https://github.com/Tenguh/Terraform-Wordpress-project.git)     


###### Steps used in Deploying WordPress on AWS using Terraform Modules

  2) ***Creating and Cloning your GitHub repository*** 
  * login into your github account, create a new repository **Terraform-Wordpress-project**
  * Open VSC and Create a folder and call it what ever name you wish. say **Terraform_WP_Project**
  * open a new terminal and select **git bash**
  * go to your repo and click on the drop down arrow by code and copy the http link


    ![github link](./ReadmeImages/4.png)
  * Go to your terminal and do a **$ git clone https://github.com/Tenguh/Terraform-Wordpress-project.git**  
  ***replace with your own repo link***
  * This will clone an empty repository.
  
  3) ***Creating VPC, Subnets, IGW, NAT, EIP and Routes using a subnet module.***
  * Choose a provider **AWS**
  * Create a file and call it **provider.tf**. The name of the file can be anything but the extension most be **.tf**
  * For the **provider.tf** file :

  
    ![image](./ReadmeImages/image-2.png)

  * For creating the VPC and subnets, create folder and call it **subnet**. under the subnet folder create three different files and name them **subnets.tf**, **outputs.tf** and **variables.tf**



    ![image](./ReadmeImages/18.png)

  * Open subnets.tf and include the below code which creates the VPC, the public subnet, private subnets, internet gateway, and routes.


    ![image](./ReadmeImages/9.png),
    ![image](./ReadmeImages/6.png),
    ![image](./ReadmeImages/10.png),
    ![image](./ReadmeImages/11.png),
    ![image](./ReadmeImages/12.png),
    ![image](./ReadmeImages/13.png)

  * Open outputs.tf and create outputs(subnet/outputs.tf)

    ![image](./ReadmeImages/7.png) 

  * Open variables.tf and create variabes.(subnet/variables.tf)

    ![image](./ReadmeImages/8.png)
  

  4) ***Creating a keypair, Security group and EC2 Instance using an ec2 module***
  * sign into your AWS account and create a *.pem* key **harriet-key**
  * Go to VSC and create a folder.
  * Call it **EC2**. 
  * under this folder create three different files and name them **ec2.tf**, **outputs.tf** and **variables.tf** 

    ![image](./ReadmeImages/17.png)

  * Open ec2.tf and create the code for security group and the instance.

   
     ![image](./ReadmeImages/1.png),
     ![image](./ReadmeImages/2.png),
     ![alt text](./ReadmeImages/image-5.png)
     

  * For ec2/outputs.tf create outputs to be used. 

    ![image](./ReadmeImages/15.png)

  * Do same for ec2/variables.tf. Create the needed variables.
  
     ![image](./ReadmeImages/16.png)
   

  5) ***Setting up RDS Database in a private subnet using a database module***
  * Create a folder and call it **database**. Under this folder create three different files and name them **database.tf, outputs.tf and variables.tf** 


      ![image](./ReadmeImages/19.png)

  * Open database.tf and create the configuration code for database security group, database instance and database subnet group. 

      ![image](./ReadmeImages/20.png),
      ![image](./ReadmeImages/21.png),
      ![image](./ReadmeImages/22.png)

  * Open database/outputs.tf and create outputs needed. 
      ![image](./ReadmeImages/23.png)

  * Open database/variables.tf and do same

      ![image](./ReadmeImages/24.png)


  6) ***Setting up the Elastic File System (EFS), mount target and security group for EFS***
  - Create folder and call it **efs**. under this folder create three different files and name them **efs.tf, outputs.tf and variables.tf**

       ![image](./ReadmeImages/25.png)

  - Open efs.tf and write code which creates efs security group, elastic file system and the mount target.

        ![image](./ReadmeImages/26.png),
        ![image](./ReadmeImages/27.png)

  - Open efs/variables.tf and create variables to be used.

      ![image](./ReadmeImages/28.png)
  
  7) ***setting up auto scaling group and policies, launch template and cloudwatch metric alarms.***
  - Create folder and call it **asg**. under this folder create three different files and name them **asg.tf, outputs.tf and variables.tf**
  
  - open asg.tf and include the following code which creates the above.
  ```
  resource "aws_launch_template" "wordpress_lt" {
  name_prefix   = "wordpress-lt"
  image_id      = var.ami_id
  instance_type = "t3.medium"
  key_name      = var.key_pair_name
  
 user_data = base64encode(templatefile("scripts/userdata.sh", { 
  endpoint      = var.db_endpoint,
  mount_script  = file("scripts/mounttarget.sh")
}))

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [var.ec2_sg_id]

  }
}
resource "aws_autoscaling_group" "wordpress_asg" {
  name                 = "wordpress-asg"
  min_size             = 2
  max_size             = 6
  desired_capacity     = 2
  health_check_type    = "ELB"
  vpc_zone_identifier  = var.subnet_ids
  target_group_arns    = var.target_group_arns

  launch_template {
    id      = aws_launch_template.wordpress_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "wordpress-asg-instance"
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "wordpress_scale_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
}
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "wordpress-high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name
  }

  alarm_description = "Scale up if CPU > 70% for 2 periods"
  alarm_actions     = [aws_autoscaling_policy.scale_up.arn]
}
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "wordpress_scale_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
}
resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "wordpress-low-cpu"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wordpress_asg.name
  }

  alarm_description = "Scale down if CPU < 30% for 2 periods"
  alarm_actions     = [aws_autoscaling_policy.scale_down.arn]
}
```

- open variables.tf and input the variables. do same for outputs.tf

```
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
```



  8)***Installation and configuration of WordPress and EFS utilities on the EC2 instance.***
  * Create a folder and call it **scripts**. 
  * Under this folder create two different files and name them **userdata.sh** and **mounttarget.sh**
  * Open userdata.sh and paste the script that installs WordPress on the instance.
  ## User data 
   Copy the userdata below and paste in the userdata.sh
 
```bash
#!/bin/bash
set -ex  # Enable debugging and stop on errors

# 1️⃣ Update System and Install Required Repositories
sudo yum update -y
sudo amazon-linux-extras enable php7.4  # Enable PHP 7.4
sudo yum install -y httpd php php-cli php-mysqlnd php-mbstring php-xml mariadb105

# 2️⃣ Start and Enable Apache Web Server
sudo systemctl start httpd
sudo systemctl enable httpd

# 3️⃣ Change Apache Permissions to Allow EC2 User
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod -R 775 /var/www

# 4️⃣ Download and Configure WordPress
cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
mv wordpress/* .  # Move files to root web directory
rm -rf wordpress latest.tar.gz
chown -R apache:apache /var/www/html

# 5️⃣ Create WordPress Config File
cp wp-config-sample.php wp-config.php

# 6️⃣ Configure WordPress Database (Replace with Your DB Details)
sed -i "s/database_name_here/wordpress/" wp-config.php
sed -i "s/username_here/harriet/" wp-config.php
sed -i "s/password_here/mydbpassword/" wp-config.php
sed -i "s/localhost/${endpoint}/" wp-config.php

# 7️⃣ Restart Apache
sudo systemctl restart httpd

```


Now open mounttarget.sh and paste the script that installs EFS utilities and automatically mounts the EFS storage on the instance.

```bash
# script to install EFS utilities and automatically mounts the EFS storage at /mnt/efs.
 #!/bin/bash
    sudo yum install -y amazon-efs-utils
    mkdir -p /mnt/efs
    mount -t efs ${aws_efs_file_system.efs.id}:/ /mnt/efs

```

8) ***Creating the main.tf, terraform.tfvars and the variable files***
  * Create a file and call it variables.tf
  * Create these variables in it 

    ![image](./ReadmeImages/31.png)

  * Create another file and call it terraform.tfvars
  * Open and create the values for each variable in the variables.tf file we just created.
  * Create a file and call it **main.tf**.
  * Open this file and create the following Modules; 

  ```
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
```


Move to the terraform directory where all the files are located 

    ![image](./ReadmeImages/34.png) 

and install the required plugins that will be used in creating your infrastructure on AWS by running the command ***$ terraform init***

  ![image](./ReadmeImages/35.png)

* Now run ***$ terraform plan*** which shows the changes that will be made to your infrastructure.

    ![image](./ReadmeImages/36.png)

* With a successfully terraform plan, we are sure our infrastucture is ok so we can now run ***terraform apply -auto-approve*** to create the infrastructure in AWS.

***Note***:
It is best practice to run 
***$ terraform apply*** 
and get a prompt to either say *yes*  for the infrastructure to be created or *no* not to create the infrastructure after reviewing.

   ![image](./ReadmeImages/37.png)
   ![image](./ReadmeImages/38.png)
   ![alt text](./ReadmeImages/39.png)

###### Open your AWS account and see all the resources created.
  ![instance](./ReadmeImages/44.png)
  ![rds](./ReadmeImages/45.png)
  ![subnetgrp](./ReadmeImages/43.png)
  ![efs](./ReadmeImages/46.png)


9) ***pushing your code to github and Login into your Database***
 - Finally push changes to repo
        
        $ git add .
        $ git commit -m "relevant commit message"
        $ git push
        

- Go to the console, open ec2 - instances
  * copy the public ip of the WordPress Instance
    ![pub ip](./ReadmeImages/image0.png)

  * Paste the public ip in a new browser and press enter
    ![installation]](./ReadmeImages/-1.png)

  * A page opens, select your language
  * Scroll right down and click continue

    ![alt text](./ReadmeImages/-2.png)

  * The ***WordPress installation Page*** opens
  * Fill in the information needed
  * Tick the comfirm password box if your password is weak
  * Click on install wordpress

    ![alt text](./ReadmeImages/-4.png)
    ![alt text](./ReadmeImages/-5.png)

  * A page opens showing successful installation
  * Click on login

    ![alt text](./ReadmeImages/-6.png)

  * Input the username or email and password you used above in installing wordpress
  * Click on Login

    ![welcome page](./ReadmeImages/-7.png)

  * This takes you to the welcome page(dashboard) of WordPress

    ![alt text](./ReadmeImages/-8.png)

        
 Finally,play around with it and do some modifications as you like .
  * you can add another user by clicking on user
  select all users.      

  ###### Destroy the infrastructure
* Go to your terminal and run 

***$ terraform destroy -auto-approve***

## 😊 Well Done everyone 😊


 ****Outcome/Benefits:****
   - **Reduced deployment time **from 4 hours (manual) → 10 minutes(automated)**.  
   - **Improved uptime with EFS (no data loss if EC2 fails).  
   - **Scalable** – Handle traffic spikes by adding EC2 instances.  
   - **Disaster recovery** – Terraform lets you rebuild infrastructure in minutes. 












