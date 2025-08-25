#!/bin/bash
# faz com que o script shell interrompa a execução imediatamente se qualquer comando retornar um erro
set -e
# Redireciona saída para log
exec > /home/ubuntu/user-data.log 2>&1
echo "Iniciando script user-data..."

# Instala Docker e Docker Compose
sudo apt update

sudo apt install -y zip
sudo apt install -y unzip
sudo apt install -y mysql-client

sudo timedatectl set-timezone America/Sao_Paulo

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

sudo apt install -y docker.io docker-compose
sudo systemctl enable --now docker
sudo usermod -aG docker ubuntu

### ───────────────────────────── ZABBIX ─────────────────────────────
sudo mkdir -p /infra/zabbix && cd /infra/zabbix
sudo tee docker-compose.yml > /dev/null <<'EOF'
version: "3.8"

services:
  db:
    image: mariadb:10.6
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: zabbix
      MYSQL_USER: zabbix
      MYSQL_PASSWORD: zabbixpass
      TZ: America/Sao_Paulo
    volumes:
      - db:/var/lib/mysql
    restart: unless-stopped

  zabbix-server:
    image: zabbix/zabbix-server-mysql:latest
    environment:
      DB_SERVER_HOST: db
      MYSQL_DATABASE: zabbix
      MYSQL_USER: zabbix
      MYSQL_PASSWORD: zabbixpass
      ZBX_ENABLE_SNMP_TRAPS: "true"
      TZ: America/Sao_Paulo
    depends_on:
      - db
    restart: unless-stopped

  zabbix-web:
    image: zabbix/zabbix-web-nginx-mysql:latest
    environment:
      DB_SERVER_HOST: db
      MYSQL_DATABASE: zabbix
      MYSQL_USER: zabbix
      MYSQL_PASSWORD: zabbixpass
      ZBX_SERVER_HOST: zabbix-server
      PHP_TZ: America/Sao_Paulo
      TZ: America/Sao_Paulo
    ports:
      - "8080:8080"
    depends_on:
      - db
      - zabbix-server
    restart: unless-stopped

volumes:
  db:
EOF

docker-compose --project-name zabbix up -d

### ──────────────────────────── GRAFANA ─────────────────────────────
sudo mkdir -p /infra/grafana && cd /infra/grafana
sudo tee docker-compose.yml > /dev/null <<'EOF'
services:
  grafana:
    image: grafana/grafana-oss:latest
    environment:

    ports:
      - "3000:3000"
    volumes:
      - data:/var/lib/grafana
    networks:
      - zabbix_default
    restart: unless-stopped      

volumes:
  data: {}

networks:
  zabbix_default:
    external: true      
EOF

sudo docker-compose --project-name grafana up -d

