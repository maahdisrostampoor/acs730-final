
# Module to deploy basic networking 
module "vpcProd" {
  source = "../../Modules/aws_network"
  #source              = "git@github.com:Dhansca/aws_network.git"
  env                = var.env
  vpcCidr            = var.vpcCidr
  publicCidrBlocks   = var.publicCidrBlocks
  prefix             = var.prefix
  defaultTags        = var.defaultTags
  privateCIDR        = var.privateCIDR
} 