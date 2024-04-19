# Provision public subnets in custom VPC
variable "publicCidrBlocks" {
  type = list(string)
  description = "Public Subnet CIDRs"
}

# VPC CIDR range
variable "vpcCidr" {
 # default     = {}
  type        = string
  description = "VPC to host static web site"
}

# Default tags
variable "defaultTags" {
 # default     = {}
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Prefix to identify resources
variable "prefix" {
#  default     = ""
  type        = string
  description = "Name prefix"
}


# Variable to signal the current environment 
variable "env" {
#  default     = ""
  type        = string
  description = "Deployment Environment"
}

variable "enableDNSSupport" {
  type    = bool
  default = true
}

variable "enableDNSHostnames" {
  type    = bool
  default = true
}


variable "privateCIDR" {
  type = list(string)
}
