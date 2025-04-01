# "Deploying WordPress on AWS with Terraform"

  - In this project, i will deploy a wordpress application on AWS EC2, use relational database (RDS) , ensuring rebust security with security groups while using Terraform to automate on AWS.

*Repository Link:*  **https://github.com/Tenguh/Terraform-Wordpress-project.git**
# Detailed Architecture Flow
# Diagram Explanation:
 - Users access WordPress via EC2 in the public subnet
 - EC2 connects to RDS (MySQL) for the database
 - EFS used for scalable storage (themes, plugins, media)
 - NAT Gateway enables EC2 instances in private subnets to download updates
 - Security Groups and IAM roles ensure secure access.


# Why Terraform
- Automates AWS resource provisioning.
- Ensures infrastructure consistency.
- Easy to scale and modify.

# The AWS Services Used and WHY
1. **EC2**
 - Host the WordPress application
 - Scalable compute power
 - Flexible instance types

 2. **VPC, Subnets, IAM & Security Groups**
 - Isolated network for security
 - Public & private subnets for controlled access
 - Grant permission to EC2 to access RDS instance.

 3. **RDS**
 - stores and manages the Wordpress Database
 - Managed database with automated backups
 - High availability and a scalable 

4. **EFS**
 - Shared storage across multiple instances
 - Automatically scales based on demand
 - Cost effective as you only pay for the storage you use and not the storage you provisioned
 - Persist Data. If the instance is stopped or terminated, data will not be lost.
 - AWS manages the underlying infrastructure for me,hence management is simplified.
 - Incase we are using multiple EC2 instances, EFS will also enable the multiple instances to access thesame file easing availability

5. **Internet Gateway & NAT Gateway**
 - Internet Gateway: Allows public access to the EC2 instance
 - NAT Gateway: Allows private resources to fetch updates securely

## Steps used in Deploying WordPress on AWS using Terraform
  **Step 1:** 
  - Set up AWS VPC with cidr ![wp-vpc](image-2.png)
  - Set up subnets(1 public and 2 private) with correct cidr ranges.![wp-subnets](image-3.png)
  - Set up Route tables(public and private routes) and associate them to their respective subnets.![route-tables](image-4.png)
  - Set up EC2 instance in the public subnet![WP-instance](image.png)
  - Set up Internet gateway![wp-igw](image-5.png) and Nat Gateway on the instance![wp-nat](image-6.png)

  **Step 2:**
  - Configure security groups which is paramount when hosting a website. AWS Security group provide essential firewall protection ensuring your WordPress site stays secured.

  **Step 3:**
  - Set up RDS Database in a private subnet.![myrdsinstance](image-7.png)![db-subnet-group](image-8.png)
 # - Set up EFS to store configuration files![efs-sg](image-1.png), plugins and website content and mounttarget ![mounttarget](image-2.png)
  - configure security groups on EC2(![ec2-sg](image-1.png)), RDS Instance and EFS to allow traffic only between them based on the ports.

  **Step 4:**
  - Install and configure WordPress on the EC2 instance using userdata script that contains the wordpress config.php to establish a connection to the RDS MySQL Instance and also connect the EC2 Instance and the RDS Instance.
  - Use script to install EFS utilities and automatically mounts the EFS storage on the instance.

  **Step 5(optional):**
  - Set up IAM Role to grant the instance permission to access the RDS Instance
  - Set up S3 to store static assets reducing load on the EC2 instance 
  - Use S3 and DynamoDB in storing and locking the statefile respectively.


## Challenges & Solutions
# Challenges: 
 - Managing Terraform state
 - Security concerns
 - Scalibility concerns

# Solution: 
 - used S3 + DynamoDB for state management
 - Proper IAM roles, security groups, and encryption
 - Used EfS to ensure scalibility 

# Conclusion & Key Takeaways
Terraform simplifies WordPress deployment on AWS

AWS services ensure scalability, security, and automation

The architecture balances public access with private security


call this function: templatefile(userdata.sh, {endpoint: var.db_endpoint })
instead of: file(userdata.sh)

update: userdata.sh
sed .. /localhost/${endpoint}/ 




