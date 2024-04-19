# Add output variables
output "publicSubnetID" {
  value = module.vpcProd.publicSubnet
}

output "vpcId" {
  value = module.vpcProd.vpcId
}
output "privateSubnetID" {
  value = module.vpcProd.privateCIDR
}