# AWS Observability Stack: Grafana & Zabbix com Terraform

Este projeto automatiza a instalação do Zabbix e Grafana usando Docker Compose em uma VM Ubuntu provisionada via Terraform na AWS. O script `user-data.sh` prepara o ambiente, instala dependências e sobe os containers necessários.

## Pré-requisitos

- Conta AWS
- Terraform instalado
- Ubuntu Server (provisionado pelo Terraform)
- Permissões de sudo
- Docker e Docker Compose (instalados pelo script)

## Configuração de Variáveis Terraform

No arquivo `variables.tf`, configure os valores conforme sua infraestrutura:

```hcl
variable "vpc_id" {
   description = "O ID da VPC existente onde os recursos serão criados."
   type        = string
   default     = "vpc-xxxxxx" # Substitua xxxx pelo ID da sua VPC
}

variable "subnet_id" {
   description = "O ID da Subnet existente onde a instância EC2 será criada."
   type        = string
   default     = "subnet-xxxxx" # Substitua xxxx pelo ID da sua Subnet
}

variable "elastic_ip_allocation_id" {
   description = "O ID de alocação do IP Elástico existente a ser associado à instância."
   type        = string
   default     = "eipalloc-xxxxx" # Substitua xxxx pelo ID do seu Elastic IP
}

variable "key_pair_name" {
   description = "O nome do par de chaves EC2 para acesso SSH."
   type        = string
   default     = "xxxxxx" # Substitua xxxx pelo nome do seu Key Pair
}

variable "ami_id" {
   description = "O AMI ID para a instância EC2."
   type        = string
   default     = "ami-0a174b8e659123575" # Substitua se necessário
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
```

Substitua os valores `xxxxxx` pelos IDs e nomes reais da sua infraestrutura AWS.

## Provisionamento com Terraform

Exemplo de configuração inicial:

```hcl
terraform {
    required_providers {
         aws = {
             source  = "hashicorp/aws"
             version = ">= 5.10.0"
         }
    }
}

provider "aws" {
    region = "sa-east-1"
}
```

1. Clone este repositório:
      ```bash
      git clone https://github.com/seu-usuario/aws-observability-stack-grafana-zabbix.git
      ```
2. Configure os arquivos Terraform para provisionar a VM Ubuntu e utilize o `user-data.sh` como script de inicialização.
3. Execute o Terraform:
      ```bash
      terraform init
      terraform apply
      ```

## Serviços

- **Zabbix**: Acesse via `http://<seu-servidor>:8080`
- **Grafana**: Acesse via `http://<seu-servidor>:3000`

## Estrutura

- `/infra/zabbix`: Docker Compose para Zabbix + MariaDB
- `/infra/grafana`: Docker Compose para Grafana

## Observações

- O script configura o timezone para `America/Sao_Paulo`.
- Logs do script são salvos em `/home/ubuntu/user-data.log`.

