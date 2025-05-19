package com.matomaylla.memorydemo.config;

import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Configuration;

/**
 * Esta clase se mantiene como referencia, pero la configuración actual de Pyroscope
 * se hace a través del javaagent en la línea de comandos (run-app.sh).
 * 
 * Para usar etiquetas personalizadas en tu código, importa y usa:
 * import io.pyroscope.labels.Pyroscope;
 * 
 * Por ejemplo:
 * Pyroscope.setGlobalTags("endpoint", "memory-test");
 * 
 * Para perfilar bloques específicos:
 * try (var ignored = Pyroscope.profileBlock("my_block_name")) {
 *     // Código para perfilar específicamente
 * }
 */
@Configuration
public class PyroscopeConfig {
    private static final Logger logger = LoggerFactory.getLogger(PyroscopeConfig.class);

    @PostConstruct
    public void init() {
        logger.info("Pyroscope está configurado a través del javaagent en la línea de comandos");
        logger.info("Para verificar la configuración, revisa que el agente aparezca en los logs de inicio");
    }
}
