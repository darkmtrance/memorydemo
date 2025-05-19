# Memory Demo Java

Una aplicación educativa para demostrar patrones de gestión de memoria y rendimiento en Java.

## Descripción

Memory Demo es un proyecto diseñado para mostrar y comparar diferentes prácticas de gestión de memoria en aplicaciones Java. A través de una serie de endpoints REST, puedes observar cómo distintas técnicas de programación afectan al rendimiento y consumo de recursos de tu aplicación.

Este proyecto es ideal para:
- Desarrolladores Java que quieren mejorar sus habilidades de optimización
- Educadores que enseñan conceptos de rendimiento y gestión de memoria
- Equipos que necesitan ejemplos prácticos de buenas y malas prácticas

## Características

- Demostración de concatenación de strings (eficiente vs ineficiente)
- Comparación entre tipos primitivos y clases wrapper
- Simulación controlada de fugas de memoria
- Script de prueba de carga para evaluación de rendimiento
- Integración con Grafana Pyroscope para continuous profiling

## Requisitos

- Java 21
- Maven
- Docker y Docker Compose (para Pyroscope)
- k6 (opcional, para pruebas de carga)

## Instalación

1. Clona el repositorio
2. Compila la aplicación con Maven:
   ```bash
   mvn clean package
   ```

## Ejecución

### Con Pyroscope (recomendado)

1. Inicia el servidor Pyroscope:
   ```bash
   docker-compose up -d pyroscope
   ```

2. Ejecuta la aplicación:
   ```bash
   ./run-app.sh
   ```

   El script automáticamente descargará el agente Pyroscope si es necesario.

3. Accede a la interfaz de Pyroscope en [http://localhost:4040](http://localhost:4040)

### Sin Pyroscope

Si no deseas usar Pyroscope, puedes ejecutar la aplicación directamente:
