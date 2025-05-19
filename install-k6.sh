#!/bin/bash

echo "Instalando k6 en WSL..."

# Verificar si gpg está instalado
if ! command -v gpg &> /dev/null; then
    echo "Instalando gpg..."
    sudo apt-get update
    sudo apt-get install -y gpg
fi

# Agregar la clave GPG de k6
sudo gpg -k
sudo gpg --no-default-keyring --keyring /usr/share/keyrings/k6-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69

# Agregar el repositorio de k6
echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" | sudo tee /etc/apt/sources.list.d/k6.list

# Actualizar e instalar k6
sudo apt-get update
sudo apt-get install k6 -y

# Verificar la instalación
k6 version

echo "✅ k6 ha sido instalado correctamente"
