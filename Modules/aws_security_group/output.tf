output "public_security_group_id" {
  value = aws_security_group.publicSecurityGroup.id
}

output "private_security_group_id" {
  value = aws_security_group.privateSecurityGroup.id
}
