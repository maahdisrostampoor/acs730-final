# Terraform Config file (main.tf). This has provider block (AWS) and config for provisioning one EC2 instance resource.  

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

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Define tags locally
locals {
  defaultTags = merge(var.defaultTags, { "env" = var.env })
}

# Create a new VPC 
resource "aws_vpc" "main" {
  cidr_block       = var.vpcCidr
  instance_tenancy = "default"
  enable_dns_support   = var.enableDNSSupport
  enable_dns_hostnames = var.enableDNSHostnames
  tags = merge(
    local.defaultTags, {
      Name = "${var.prefix}-${var.env}-vpc"
    }
  )
}

# Add provisioning of the public subnetin the default VPC
resource "aws_subnet" "publicSubnet" {
  count             = length(var.publicCidrBlocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.publicCidrBlocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    local.defaultTags, {
      Name = "${var.prefix}-${var.env}-public-subnet-${count.index+1}"
    }
  )
}


# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.defaultTags,
    {
      "Name" = "${var.prefix}-${var.env}-igw"
    }
  )
}

# Route table to route add default gateway pointing to Internet Gateway (IGW)
resource "aws_route_table" "publicSubnets" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.prefix}-${var.env}-route-public-subnets"
  }
}

# Associate subnets with the custom route table
resource "aws_route_table_association" "publicRouteTableAssociation" {
  count          = length(aws_subnet.publicSubnet[*].id)
  route_table_id = aws_route_table.publicSubnets.id
  subnet_id      = aws_subnet.publicSubnet[count.index].id
}



# Add provisioning of the private subnet the default VPC
resource "aws_subnet" "privateSubnet" {
  count             = length(var.privateCIDR)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.privateCIDR[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    local.defaultTags, {
      Name = "${var.prefix}-${var.env}-private-subnet-${count.index + 1}"
    }
  )
}


# Create Nat Gateway
resource "aws_nat_gateway" "ngw" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.publicSubnet[0].id
    tags = merge(local.defaultTags,
    {
      "Name" = "${var.prefix}-${var.env}-natGw"
    }
  )
}

resource "aws_route_table" "PrivateSubnet" {
  vpc_id                    = aws_vpc.main.id
  route {
    cidr_block              = "0.0.0.0/0"
    nat_gateway_id          = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "${var.prefix}-${var.env}-route-private-subnet"
  }
}

resource "aws_route_table_association" "privateRouteTableAssociation" {
  route_table_id = aws_route_table.PrivateSubnet.id
  subnet_id      = aws_subnet.privateSubnet[0].id
}

# resource "aws_eip" "ElasticIp" {
#   instance = aws_instance.ElasticIp.id
# }
