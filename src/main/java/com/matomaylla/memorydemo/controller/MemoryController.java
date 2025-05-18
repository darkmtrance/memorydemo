package com.matomaylla.memorydemo.controller;


import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
public class MemoryController {
    // --- Ejemplo 1: Concatenación de Strings ---

    /**
     * Endpoint que demuestra la concatenación ineficiente de Strings usando el operador '+'.
     * Esto crea muchos objetos String intermedios, consumiendo más memoria y tiempo.
     * @param count Número de veces que se concatenará la cadena.
     * @return Mensaje indicando el tiempo de ejecución.
     */
    @GetMapping("/concat-ineficiente")
    public String inefficientStringConcat(@RequestParam(defaultValue = "10000") int count) {
        long startTime = System.currentTimeMillis();
        String result = "";
        for (int i = 0; i < count; i++) {
            // ¡Ineficiente! Cada '+' crea un nuevo objeto String
            result += "data" + i;
        }
        long endTime = System.currentTimeMillis();
        return "Concatenación ineficiente completada en " + (endTime - startTime) + " ms.";
    }

    /**
     * Endpoint que demuestra la concatenación eficiente de Strings usando StringBuilder.
     * StringBuilder modifica una única instancia, siendo mucho más eficiente para múltiples concatenaciones.
     * @param count Número de veces que se concatenará la cadena.
     * @return Mensaje indicando el tiempo de ejecución.
     */
    @GetMapping("/concat-eficiente")
    public String efficientStringConcat(@RequestParam(defaultValue = "10000") int count) {
        long startTime = System.currentTimeMillis();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < count; i++) {
            // Eficiente: StringBuilder modifica la misma instancia
            sb.append("data").append(i);
        }
        String result = sb.toString(); // Convertir a String al final
        long endTime = System.currentTimeMillis();
        return "Concatenación eficiente completada en " + (endTime - startTime) + " ms.";
    }

    // --- Ejemplo 2: Tipos Primitivos vs. Wrappers ---

    /**
     * Endpoint que demuestra el uso de Wrapper classes (Integer) en una lista grande.
     * Cada Integer es un objeto, lo que consume más memoria que un tipo primitivo.
     * @param count Número de elementos en la lista.
     * @return Mensaje indicando el tiempo de ejecución.
     */
    @GetMapping("/wrapper-list")
    public String wrapperList(@RequestParam(defaultValue = "100000") int count) {
        long startTime = System.currentTimeMillis();
        List<Integer> numbers = new ArrayList<>();
        for (int i = 0; i < count; i++) {
            // Usando Integer (Wrapper class), crea un objeto por cada número
            numbers.add(i);
        }
        // Para evitar que la lista sea optimizada por el GC inmediatamente en algunos casos de benchmark simple
        // podemos hacer algo trivial con ella, aunque en una app real esto no sería necesario.
        // System.out.println("Lista de Wrappers creada con tamaño: " + numbers.size()); // Descomentar para debugging
        long endTime = System.currentTimeMillis();
        // Opcional: Limpiar la lista explícitamente para liberar memoria más rápido en un entorno de prueba
        // numbers = null; // Esto ayuda al GC, pero la fuga real ocurre si la referencia se mantiene viva
        return "Lista de Wrappers creada con " + count + " elementos en " + (endTime - startTime) + " ms.";
    }

    /**
     * Endpoint que demuestra el uso de tipos primitivos (int) en un array grande.
     * Los tipos primitivos ocupan menos memoria y son más eficientes.
     * Nota: No se puede usar List<int>, por eso usamos un array primitivo.
     * @param count Número de elementos en el array.
     * @return Mensaje indicando el tiempo de ejecución.
     */
    @GetMapping("/primitive-array")
    public String primitiveArray(@RequestParam(defaultValue = "100000") int count) {
        long startTime = System.currentTimeMillis();
        int[] numbers = new int[count];
        for (int i = 0; i < count; i++) {
            // Usando tipo primitivo int, más eficiente en memoria
            numbers[i] = i;
        }
        // Para evitar que el array sea optimizado por el GC inmediatamente
        // System.out.println("Array de primitivos creado con tamaño: " + numbers.length); // Descomentar para debugging
        long endTime = System.currentTimeMillis();
        // Opcional: Limpiar el array explícitamente
        // numbers = null; // Esto ayuda al GC
        return "Array de primitivos creado con " + count + " elementos en " + (endTime - startTime) + " ms.";
    }

    // --- Ejemplo 3: Posible Fuga de Memoria (Lista Estática) ---
    // ¡ADVERTENCIA! Este es un ejemplo de CÓMO podría ocurrir una fuga.
    // En una aplicación real, DEBES tener cuidado con las colecciones estáticas
    // que almacenan objetos que no se limpian.

    private static final List<Object> leakList = new ArrayList<>();

    /**
     * Endpoint que simula una posible fuga de memoria añadiendo objetos a una lista estática.
     * Cada llamada añade objetos que NUNCA son eliminados, haciendo que la lista crezca indefinidamente
     * y potencialmente cause un OutOfMemoryError con el tiempo.
     * @param count Número de objetos a añadir a la lista "con fuga".
     * @return Mensaje indicando cuántos objetos se añadieron.
     */
    @GetMapping("/simular-fuga")
    public String simulateMemoryLeak(@RequestParam(defaultValue = "1000") int count) {
        for (int i = 0; i < count; i++) {
            // Añadir un objeto simple a la lista estática
            leakList.add(new Object());
        }
        return "Añadidos " + count + " objetos a la lista con fuga. Tamaño actual de la lista: " + leakList.size();
    }

    /**
     * Endpoint para limpiar la lista estática que simula la fuga.
     * Esto permite "resetear" el ejemplo de fuga.
     * @return Mensaje indicando que la lista ha sido limpiada.
     */
    @GetMapping("/limpiar-fuga")
    public String clearMemoryLeak() {
        leakList.clear();
        // Sugerencia al GC, no garantiza la recolección inmediata
        System.gc();
        return "Lista con fuga limpiada. Tamaño actual de la lista: " + leakList.size();
    }
}
