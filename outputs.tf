output "ec2_instance_id" {
  description = "O ID da instância EC2 criada."
  value       = aws_instance.monitoring_instance.id
}

output "ec2_elastic_ip" {
  description = "O endereço IP Elástico atribuído à instância EC2."
  value       = aws_eip_association.eip_assoc.public_ip
}

