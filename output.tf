output "ec2_public_ip" {
  value = aws_instance.ec2.public_ip
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.demo_table.name
}