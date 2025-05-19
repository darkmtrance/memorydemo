#!/bin/bash
echo "Iniciando aplicacion con memoria minima 512MB y maxima 1GB..."
java -Xms512m -Xmx1024m -jar target/memorydemo-0.0.1-SNAPSHOT.jar
