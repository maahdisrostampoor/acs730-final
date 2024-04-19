
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

# Variable to signal the current environment 
variable "instance_ip" {
#  default     = ""
  type        = string
  description = "Deployment Environment"
}
variable "create_security_group" {
  type    = bool
  default = true  # Set default value to true to create the security group by default
}