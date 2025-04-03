# "Deploying WordPress on AWS with RDS using Terraform Modules"

  **Overview**
  In this project, i will walk you through deploying a wordpress application on AWS EC2, with relational database (RDS) , ensuring rebust security with security groups while using Terraform modules to automate on AWS.

  ***Prerequisite***
  - Have an AWS account
  - Install Visual Studio Code and Terraform
  - Configure terraform to use your AWS account(AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY)
  - Install AWS CLI

*Repository Link:* **https://github.com/Tenguh/Terraform-Wordpress-project.git**


# Detailed Architecture Flow
![Architectural Diagram](<_WordPress with File share and RDS MySQL Database.jpg>)
# Diagram Explanation:
 - Users access WordPress via EC2 in the public subnet
 - EC2 connects to RDS (MySQL) for the database
 - EFS used for scalable storage (themes, plugins, media)
 - NAT Gateway enables EC2 instances in private subnets to download updates
 - Security Groups ensure secure access.


# Why Terraform
- Free and open source IaC tool
- Automates AWS resource provisioning.
- Ensures infrastructure consistency.
- Easy to scale and modify.

# The AWS Services Used and WHY
1. **EC2**
 - Host the WordPress application and databases
 - Scalable compute power
 - Flexible instance types

 2. **VPC, Subnets,& Security Groups**
 - Isolated network for security
 - Public & private subnets for controlled access

 3. **RDS**
 - stores and manages the Wordpress Database
 - Managed database with automated backups
 - Highly available and scalable 

4. **EFS**
 - Automatically scales based on demand
 - Cost effective as you only pay for the storage you use and not the storage you provisioned
 - Persist Data. If the instance is stopped or terminated, data will not be lost.
 - AWS manages the underlying infrastructure for me,hence management is simplified.
 - Incase you decide to use multiple EC2 instances, EFS will also enable the multiple instances to access thesame file easing availability

5. **Internet Gateway & NAT Gateway**
 - Internet Gateway: Allows public access to the EC2 instance
 - NAT Gateway: Allows private resources to fetch updates securely

## Steps used in Deploying WordPress on AWS using Terraform Modules

  **Step 1: Creating and Cloning your GitHub repository** 
  - login into your github account, create a new repository **https://github.com/Tenguh/Terraform-Wordpress-project.git**
  - Open VSC and Create a folder and call it what ever name you wish. say **Terraform_WP_Project**
  - open a new terminal and select **git bash**
  - go to your repo and click on the drop down arrow by code and copy the http link![github link](image-4.png)
  - Go to your terminal and do a **git clone https://github.com/Tenguh/Terraform-Wordpress-project.git** *replace with your own repo link*
  - this will clone an empty repository.

  **Step 2: Creating VPC, Subnets, IGW, NAT, EIP and Routes using a subnet module .**
  - Choose a provider **AWS**
  - Create a file and call it **provider.tf**. The name of the file can be anything but the extension most be **.tf**
  - Copy and past below code into **provider.tf** ![provider.tf](image-5.png)
  - For creating the VPC and subnets, create folder and call it **subnet**. under the subnet folder create three different files and name them **subnets.tf, outputs.tf and variables.tf** ![module](image-18.png)
  - Open subnets.tf and paste the below code which creates the VPC, the public subnet, private subnets, internet gateway, and routes.![vpc & public subnet](image-9.png),![pvt subnets](image-6.png), ![gateway](image-10.png)![pub rtb](image-11.png), ![prvt route](image-12.png),![ass route](image-13.png)
  - Open outputs.tf and paste this code.![outputs.tf](image-7.png) 
  - Open variables.tf and paste this code.![variables.tf](image-8.png)
  

  **Step 3: Creating a keypair, Security group and EC2 Instance using an ec2 module**
  - sign into your AWS account and create a *.pem* key **harriet-key**
  - Create folder and call it **EC2**. under this folder create three different files and name them **ec2.tf, outputs.tf and variables.tf** ![module](image-17.png)
  - Open ec2.tf and paste the below code which creates security groups and the instance.![sg1](image.png), ![sg2](image-1.png),![AMI](image-2.png), ![instance](image-14.png)
  - Open ec2/outputs.tf and paste this code. ![ec2/output](image-15.png)
  - Open ec2/variables.tf and paste this code.![ec2/var](image-16.png)
   

  ***Step 4:Setting up RDS Database in a private subnet using a database module***
  - Create folder and call it **database**. under this folder create three different files and name them **database.tf, outputs.tf and variables.tf** ![module](image-19.png)
  - Open database.tf and paste the below code which creates database security group, database instance and database subnet group. ![db-sg](image-20.png), ![db-instance](image-21.png), ![subnet-grp](image-22.png)
  - Open database/outputs.tf and paste this code. ![db/output](image-23.png)
  - Open database/variables.tf and paste this code. ![db/var](image-24.png)


  ***Step 5: Setting up the Elastic File System (EFS), mount target and security group for EFS***
  - Create folder and call it **efs**. under this folder create three different files and name them **efs.tf, outputs.tf and variables.tf**![Module](image-25.png)
  - Open efs.tf and paste the below code which creates efs security group, elastic file system and the mount target.![efs&mounttarget](image-26.png), ![efs-sg](image-27.png)
  - Open efs/variables.tf and paste this code ![efs/var](image-28.png)
  

  ***Step 6:Installation and configuration of WordPress and EFS utilities on the EC2 instance.***
  - Create a folder and call it **scripts**. under this folder create two different files and name them **userdata.sh and mounttarget.sh** ![scripts](image-32.png)
  - Open userdata.sh and paste the script that installs WordPress on the instance.
  - This script contains the wordpress config.php to establish a connection to the RDS MySQL instance and also connect the EC2 Instance and the RDS Instance. 
  - Open mounttarget.sh and paste the script that installs EFS utilities and automatically mounts the EFS storage on the instance. ![script/mounttarget](image-33.png)


  ***Step 7:Creating the main.tf, terraform.tfvars and the variable files***
  - Create a file and call it variables.tf
  - Paste these variables in it ![variables](image-31.png)
  - Create another file and call it terraform.tfvars
  - *Open and create the values for each variable in the variables.tf file we just created.*
  - Create a file and call it **main.tf**.
  - Open this file and paste the following Modules; ![ec2&subnets](image-29.png), ![databas&efs](image-30.png)

Move to the terraform directory where all the files are located ![location](image-34.png) and 
Install the required plugins that will be used in creating your infrastructure on AWS by running the command *terraform init* 

![initializing](image-35.png)

Now run *terraform plan* which shows the changes that will be made to your infrastructure.
![plan](image-36.png)

with a successfully terraform, we are sure our infrastucture is ok so we can now run *terraform apply -auto-approve* to create the infrastructure in AWS.![creation](image-37.png)![creation](image-38.png)![alt text](image-39.png)

Open your AWS account and see all the resources created.
![instance](image-44.png)
![rds](image-45.png)
!![subnetgrp](image-43.png)
![efs](image-46.png)





## Challenges & Solutions
# Challenges: 
 - Managing Terraform state
 - Security concerns
 - Scalibility concerns

# Solution: 
 - used S3 + DynamoDB for state management
 - Set proper security groups and encryption
 - Used EfS to ensure scalibility 

# Conclusion & Key Takeaways
Terraform simplifies WordPress deployment on AWS
AWS services ensure scalability, security, and automation
The architecture balances public access with private security





