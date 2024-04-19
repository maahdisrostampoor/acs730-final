
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
