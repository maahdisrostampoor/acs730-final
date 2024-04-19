
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.27"
    }
  }

  required_version = ">=0.14"
}
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

data "terraform_remote_state" "publicSubnet" {
  backend = "s3" 
  config = {
    bucket         = "acsprojectbucket"
    key            = "prod/network/terraform.tfstate"
    region         = "us-east-1" 
  }
}

# Module to deploy basic networking 
module "SecurityGroup" {
  source = "../../Modules/aws_security_group"
  #source              = "git@github.com:Dhansca/aws_network.git"
  env                = var.env
  prefix             = var.prefix
  defaultTags        = var.defaultTags
  instance_ip        = aws_instance.bastion.private_ip
} 

# Data source for AMI id
data "aws_ami" "latestAmazonLinux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Define tags locally
locals {
  defaultTags = merge(var.defaultTags, { "env" = var.env })
  namePrefix  = "${var.prefix}-${var.env}"
}

# Webservers in Public Subnet
resource "aws_instance" "webServer" {
  count                       = length(var.selected_subnets)
  ami                         = data.aws_ami.latestAmazonLinux.id
  instance_type               = lookup(var.instanceType, var.env)
  key_name                    = aws_key_pair.webServerKey.key_name
  security_groups             = [module.SecurityGroup.public_security_group_id]
  subnet_id                   = element(data.terraform_remote_state.publicSubnet.outputs.publicSubnetID, var.selected_subnets[count.index])
  associate_public_ip_address = true
  user_data = templatefile("${path.module}/install_httpd.sh",
    {
      env    = upper(var.env),
      prefix = upper(var.prefix)
    }
  )
  tags = merge(local.defaultTags, {
      "Name" = "${local.namePrefix}-webServer-${count.index+1}"
      "Type" = "Webserver"
      
    })
}

resource "aws_key_pair" "webServerKey" {
  key_name   = local.namePrefix
  public_key = file("${local.namePrefix}.pub")
}



#Bastion deployment
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.latestAmazonLinux.id
  instance_type               = lookup(var.instanceType, var.env)
  key_name                    = aws_key_pair.bastionKey.key_name
  subnet_id                   = data.terraform_remote_state.publicSubnet.outputs.publicSubnetID[1]
  security_groups             = [module.SecurityGroup.public_security_group_id]
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
  tags = merge(local.defaultTags,
    {
      "Name" = "${local.namePrefix}-bastion"
      "Type" = "Bastion"
    }
  )
}
resource "aws_key_pair" "bastionKey" {
  key_name   = "${local.namePrefix}-Bastion"
  public_key = file("${local.namePrefix}-Bastion.pub")
}


# Vm in private subnet
resource "aws_instance" "privateVm" {
  count                       = 2
  ami                         = data.aws_ami.latestAmazonLinux.id
  instance_type               = lookup(var.instanceType, var.env)
  key_name                    = aws_key_pair.privateVmKey.key_name
  security_groups             = [module.SecurityGroup.private_security_group_id]
  subnet_id                   = data.terraform_remote_state.publicSubnet.outputs.privateSubnetID[count.index]
  tags = merge(local.defaultTags, {
      "Name" = "${local.namePrefix}-PrivateVM-${count.index+1}"
      "Type" = "Webserver"
      
    })
}

resource "aws_key_pair" "privateVmKey" {
  key_name   = "${local.namePrefix}-PrivateVm"
  public_key = file("${local.namePrefix}-PrivateVm.pub")
}