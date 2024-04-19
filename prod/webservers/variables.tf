# Instance type
variable "instanceType" {
  default = {
    "Prod"    = "t2.small"
    "Staging" = "t2.micro"
  }
  description = "Type of the instance"
  type        = map(string)
}

# Default tags
variable "defaultTags" {
  default = {
    "Owner" = "Group2"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Prefix to identify resources
variable "prefix" {
  default     = "Group2"
  type        = string
  description = "Name prefix"
}


# Variable to signal the current environment 
variable "env" {
  default     = "Prod"
  type        = string
  description = "Deployment Environment"
}

variable "selected_subnets" {
  type    = list(number)
  default = [0, 2, 3]  # Indexes of the subnets to use (first, third, and fourth)
}

