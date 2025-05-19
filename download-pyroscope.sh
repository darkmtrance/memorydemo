#!/bin/bash

PYROSCOPE_VERSION="0.13.1"
DOWNLOAD_URL="https://github.com/grafana/pyroscope-java/releases/download/v${PYROSCOPE_VERSION}/pyroscope.jar"
OUTPUT_FILE="pyroscope.jar"
echo "Descargando Pyroscope Agent v${PYROSCOPE_VERSION}..."

# Intentar descargar con curl si está disponible
if command -v curl &> /dev/null; then
    curl -L -o "${OUTPUT_FILE}" "${DOWNLOAD_URL}"
# Si no está curl, intentar con wget
elif command -v wget &> /dev/null; then
    wget -O "${OUTPUT_FILE}" "${DOWNLOAD_URL}"
else
    echo "Error: Se requiere curl o wget para descargar el archivo"
    exit 1
fi

# Verificar si la descarga fue exitosa
if [ $? -eq 0 ] && [ -f "${OUTPUT_FILE}" ]; then
    echo "Descarga completada exitosamente: ${OUTPUT_FILE}"
    echo "Tamaño del archivo: $(ls -lh ${OUTPUT_FILE} | awk '{print $5}')"
else
    echo "Error: La descarga falló"
    exit 1
fi
