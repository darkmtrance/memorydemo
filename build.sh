#!/bin/bash

echo "=== Script de compilación y empaquetado para WSL ==="

# Dar permisos de ejecución al wrapper de Maven si no los tiene
chmod +x ./mvnw

echo "=== Información del sistema ==="
echo "Java version:"
java -version
echo ""

echo "=== Limpiando y compilando el proyecto ==="
./mvnw clean package -DskipTests

# Verificar si la compilación fue exitosa
if [ $? -eq 0 ]; then
    echo ""
    echo "=== Compilación exitosa ==="
    echo "JAR generado en: target/memorydemo-0.0.1-SNAPSHOT.jar"
    echo "Tamaño del JAR: $(ls -lh target/memorydemo-0.0.1-SNAPSHOT.jar | awk '{print $5}')"
    echo ""
    echo "Para ejecutar el JAR:"
    echo "java -jar target/memorydemo-0.0.1-SNAPSHOT.jar"
else
    echo ""
    echo "=== Error en la compilación ==="
    exit 1
fi
