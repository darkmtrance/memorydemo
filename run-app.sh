#!/bin/bash

# Detectar sistema operativo
OS_NAME=$(uname -s 2>/dev/null || echo "Unknown")
IS_WINDOWS=false

# Comprobar si es Windows
if [[ "$OS_NAME" == "Unknown" ]] && [[ -n "$WINDIR" || -n "$windir" ]]; then
    IS_WINDOWS=true
    echo "Sistema operativo detectado: Windows"
elif [[ "$OS_NAME" == *"MINGW"* || "$OS_NAME" == *"MSYS"* || "$OS_NAME" == *"CYGWIN"* ]]; then
    IS_WINDOWS=true
    echo "Sistema operativo detectado: Windows (Git Bash/MinGW/Cygwin)"
else
    echo "Sistema operativo detectado: $OS_NAME"
fi

PYROSCOPE_AGENT="./pyroscope-agent.jar"
PYROSCOPE_VERSION="0.13.1"
PYROSCOPE_DOWNLOAD_URL="https://repo1.maven.org/maven2/io/pyroscope/agent/${PYROSCOPE_VERSION}/agent-${PYROSCOPE_VERSION}.jar"
PYROSCOPE_SERVER="http://localhost:4040"

# Verificar si Pyroscope está en ejecución
PYROSCOPE_RUNNING=false
if command -v curl &> /dev/null; then
    if curl -s -f "$PYROSCOPE_SERVER/ready" &> /dev/null; then
        echo "✅ Pyroscope server detectado en $PYROSCOPE_SERVER"
        PYROSCOPE_RUNNING=true
    else
        echo "⚠️ Advertencia: No se puede conectar al servidor Pyroscope en $PYROSCOPE_SERVER"
        echo "   Asegúrate de que el servidor esté en ejecución con 'docker-compose up -d pyroscope'"
    fi
fi

# Configuración de opciones del agente Pyroscope
PYROSCOPE_OPTS=""

# En Windows, no usamos el agente Java ya que no es compatible
if [ "$IS_WINDOWS" = true ]; then
    echo "⚠️ Pyroscope Java Agent no es compatible con Windows."
    echo "   Se utilizará el modo programático a través de la clase PyroscopeConfig."
    
    # Pasamos las propiedades para que la configuración programática las use
    PYROSCOPE_OPTS="-Dpyroscope.application.name=memorydemo \
                    -Dpyroscope.server.address=$PYROSCOPE_SERVER \
                    -Dpyroscope.profiling.enabled=$PYROSCOPE_RUNNING \
                    -Dpyroscope.use.agent=false"
else
    # En sistemas compatibles, descargamos e intentamos usar el agente
    if [ ! -f "$PYROSCOPE_AGENT" ]; then
        echo "Descargando Pyroscope Agent ${PYROSCOPE_VERSION}..."
        if command -v curl &> /dev/null; then
            curl -L "$PYROSCOPE_DOWNLOAD_URL" -o "$PYROSCOPE_AGENT"
        elif command -v wget &> /dev/null; then
            wget -O "$PYROSCOPE_AGENT" "$PYROSCOPE_DOWNLOAD_URL"
        else
            echo "Error: curl o wget no encontrados. No se puede descargar el agente."
        fi
        
        if [ ! -f "$PYROSCOPE_AGENT" ]; then
            echo "Error al descargar Pyroscope Agent. Continuando sin perfilado."
        else
            echo "Pyroscope Agent descargado exitosamente."
        fi
    fi

    # Configurar el agente si existe y si Pyroscope está en ejecución
    if [ -f "$PYROSCOPE_AGENT" ] && [ "$PYROSCOPE_RUNNING" = true ]; then
        PYROSCOPE_OPTS="-javaagent:$PYROSCOPE_AGENT \
                        -Dpyroscope.application.name=memorydemo \
                        -Dpyroscope.server.address=$PYROSCOPE_SERVER \
                        -Dpyroscope.profiling.enabled=true \
                        -Dpyroscope.format=jfr \
                        -Dpyroscope.profiler.event=itimer \
                        -Dpyroscope.profiler.lock=0 \
                        -Dpyroscope.profiler.alloc=0 \
                        -Dpyroscope.use.agent=true"
        echo "Pyroscope Agent configurado correctamente."
    else
        echo "⚠️ Pyroscope Agent no configurado. Continuando sin perfilado."
        PYROSCOPE_OPTS="-Dpyroscope.profiling.enabled=false \
                        -Dpyroscope.use.agent=false"
    fi
fi

echo "Iniciando aplicación con memoria mínima 512MB y máxima 1GB..."
java $PYROSCOPE_OPTS -Xms512m -Xmx1024m -jar target/memorydemo-0.0.1-SNAPSHOT.jar
