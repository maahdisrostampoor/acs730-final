
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

# Define tags locally
locals {
  defaultTags = merge(var.defaultTags, { "env" = var.env })
  namePrefix  = "${var.prefix}-${var.env}"
}


data "terraform_remote_state" "publicSubnet" {
  backend = "s3" 
  config = {
    bucket         = "acsprojectbucket"
    key            = "prod/network/terraform.tfstate"
    region         = "us-east-1" 
  }
}

#Public Security Group
resource "aws_security_group" "publicSecurityGroup" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.publicSubnet.outputs.vpcId

  ingress {
    description      = "HTTP from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge(local.defaultTags,
    {
      "Name" = "${var.prefix}-${var.env}-public-sg"
    }
  )
}
