# Define a provider https://www.terraform.io/docs/providers/index.html
# We need to install the needed provider installations
# per project basis which plugins will be used
# We will use AWS, https://registry.terraform.io/providers/hashicorp/aws/latest/docs

# Configure the AWS Provider with access key details
# Authentication, be carefull, you will see these credentials just once. So after creating you have to save credentials csv file.

provider "aws" {
  region  = "us-east-1"
  access_key = "AKIAVBKYQAW2CJ7YNYNW"
  secret_key = "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"
}

# resource "<provider>_<resource>" "name"{
#     config options ...
#     key = "value1"
#     key2 = "value2"
# }

# In the documentation, (https://registry.terraform.io/providers/hashicorp/aws/latest/docs), Go to AWS>EC2>Resources>aws_instance
# This is how to deploy EC2 instance


resource "aws_instance" "techproed_server_1" {
  ami           = "ami-098f16afa9edf40be" /* Find AMI type from AWS console, this is redhat 8 image in us-east-1 region */
  instance_type = "t2.micro" /* Free tier eligible */
  subnet_id = aws_subnet.techproed-subnet.id  /* We tell this after a while */

  tags = {
    Name = "techproed_server_1"
  }
}

resource "aws_instance" "techproed_default" {
  ami           = "ami-098f16afa9edf40be" /* Find AMI type from AWS console, this is redhat 8 image in us-east-1 region */
  instance_type = "t2.micro" /* Free tier eligible */

  tags = {
    Name = "techproed_default"
  }
}

# resource "aws_instance" "techproed_server_2" {
#   ami           = "ami-098f16afa9edf40be" /* Find AMI type from AWS console, this is redhat 8 image in us-east-1 region */
#   instance_type = "t2.micro" /* Free tier eligible */

#   tags = {
#     Name = "techrpoed_server_2"
#   }
# }

# Before running codes you need to install plugins which are needed by this terraform project
# you have to run the below command in the terminal of the project directory.
#
# $ terraform init
# -> It will initialize the backend, download/install required plugins
# -> We should see something like "Terraform has been succesfully initialized" 
#
# $ terraform plan
# -> A quick sanity check of your code, that will show that you are not breaking anything
# -> "+" in the output means it is adding some resource
# -> You will see lots of "(knwon after apply)" outputs, which means will be defined and set while installing
# -> "-" means removing some resource
# -> "~" means modifying an existing resource
#
# $ terraform apply
# -> output will be similar to "terraform apply"
# -> it will ask for approval
# -> it will take some time to complete and at the end it will give you a overview
#
# If we apply again, it will not re-deploy a new instance.
# BECAUSE, ACTUALLY, WHAT WE ARE DOING WHILE USING TERRAFOMR IS DEFINING OUR INFRASTRUCTURE
#
# Destroy instances
# $ terraform destroy
# -> It will destroy the every single resource which are defined here.
# -> deleting resources from code and applying it is the same as destroy
#

# VPC
# Again copy required code from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc

resource "aws_vpc" "techproed-vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_support = "true" /* We need to auto-created DNS record for auto-created public IP */
  enable_dns_hostnames = "true" /* We need to auto-created DNS record for auto-created public IP */
  tags = {
    Name = "techproed-vpc"
  }
}

# And we will create a subnet within this VPC, https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet

resource "aws_subnet" "techproed-subnet" {
  vpc_id     = aws_vpc.techproed-vpc.id
# For getting VPC ID , we simply copied <provider>_<resource>.<resource-name>.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true" /* We need to "Enable auto-assign public IPv4 address" */
  tags = {
    Name = "techproed-subnet"
  }
}

# THE ORDER IS NOT IMPORTANT, IT WILL FIGURE OUT WHICH WILL BE CREATED FIRSTLY







