# Cria o Security Group

resource "aws_security_group" "monitoring_sg" {
  name_prefix = "automacao" # Usamos name_prefix para evitar conflitos se o módulo for usado mais de uma vez
  description = "Permite trafego de entrada especifico para monitoramento"
  vpc_id      = var.vpc_id
  
  # Regras de entrada para as portas especificadas

  ingress {
    description = "Permitir HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_ingress_cidrs
  }

    ingress {
    description = "Permitir SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ingress_cidrs
  }

  ingress {
    description = "Permitir HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_ingress_cidrs
  }

  ingress {
    description = "Permitir porta personalizada 10051 zabbix"
    from_port   = 10051
    to_port     = 10051
    protocol    = "tcp"
    cidr_blocks = var.allowed_ingress_cidrs
  }

  ingress {
    description = "Permitir porta personalizada 3000 grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = var.allowed_ingress_cidrs
  }

  # Regra de saída para permitir todo o tráfego de saída

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "monitoramento-sg"
  }
}

# Cria a Instância EC2

resource "aws_instance" "monitoring_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.monitoring_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  

    
  root_block_device {
    volume_size = var.root_block_device_size # Use the variable for size
    volume_type = "gp2"                      # You can choose gp2, gp3, io1, etc. gp2 is common.
    delete_on_termination = true             # Volume is deleted when instance terminates
  }

  # Referencia o arquivo user-data.sh de outra pasta dentro do módulo

  user_data = file("user-data.sh")

  # Garante que o Security Group e o Perfil de Instância sejam criados antes da instância
  depends_on = [
    aws_security_group.monitoring_sg,
    aws_iam_instance_profile.ec2_profile
  ]

  tags = {
    Name = "monitoramento"
  }
}

# Associa o IP Elástico existente com a nova instância

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.monitoring_instance.id
  allocation_id = var.elastic_ip_allocation_id
  # Garante que a instância seja criada antes da associação do EIP
  depends_on = [aws_instance.monitoring_instance]
}

