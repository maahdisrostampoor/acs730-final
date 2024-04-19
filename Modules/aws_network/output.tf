# Add output variables
output "publicSubnet" {
  value = aws_subnet.publicSubnet[*].id
}

output "vpcId" {
  value = aws_vpc.main.id
}
output "privateCIDR" {
  value = aws_subnet.privateSubnet[*].id
}

# output "ElasticIp" {
#   value = aws_eip.ElasticIp.id
# }