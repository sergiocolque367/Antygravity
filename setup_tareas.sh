#!/bin/bash
set -e

echo "=== Iniciando Tareas ==="

echo "1. Creando grupo esbirros..."
sudo groupadd esbirros || echo "El grupo ya existe, continuando..."

echo "2. Creando usuario sergio..."
sudo useradd -u 3196 -m -s /bin/bash sergio || echo "El usuario ya existe, continuando..."

echo "3. Creando usuario paolo..."
sudo useradd -u 4003 -d /ezbirros/ -m -U -s /bin/bash paolo || echo "El usuario ya existe, continuando..."

echo "4. Buscando archivos de paolo..."
sudo find / -user paolo > paolo_user 2>/dev/null || true
echo "Archivo paolo_user creado. Contiene $(wc -l < paolo_user) líneas."

echo "5. Buscando 'err' en /var/log..."
sudo bash -c 'grep -rIi "err" /var/log/ > /root/var.log || true'
echo "Resultados guardados en /root/var.log."

echo "6. Instalando Docker..."
export DEBIAN_FRONTEND=noninteractive
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

echo "Habilitando e iniciando Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Verificando Docker..."
sudo docker run hello-world

echo "Agregando usuario $USER al grupo docker..."
sudo usermod -aG docker "$USER"

echo "=== Tareas Finalizadas ==="
echo "NOTA: Por favor cierra sesión y vuelve a entrar para usar Docker sin sudo."
