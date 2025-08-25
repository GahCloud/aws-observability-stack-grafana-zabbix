variable "vpc_id" {
  description = "O ID da VPC existente onde os recursos serão criados."
  type        = string
  default     = "vpc-xxxxxx"
}

variable "subnet_id" {
  description = "O ID da Subnet existente onde a instância EC2 será criada."
  type        = string
  default     = "subnet-xxxxx"
}

variable "elastic_ip_allocation_id" {
  description = "O ID de alocação do IP Elástico existente a ser associado à instância."
  type        = string
  default     = "eipalloc-xxxxx"
}

variable "key_pair_name" {
  description = "O nome do par de chaves EC2 para acesso SSH."
  type        = string
  default     = "xxxxxx"
}

variable "ami_id" {
  description = "O AMI ID para a instância EC2."
  type        = string
  default     = "ami-0a174b8e659123575"
}

variable "instance_type" {
  description = "O tipo de instância EC2."
  type        = string
  default     = "t3.small"
}

variable "root_block_device_size" {
  description = "O tamanho do volume EBS raiz em GB para a instância EC2."
  type        = number
  default     = 20
}

variable "allowed_ingress_cidrs" {
  description = "Lista de CIDR blocks permitidos para acesso ao Security Group (SSH, HTTP, etc)."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

