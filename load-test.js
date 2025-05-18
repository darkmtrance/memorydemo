import http from 'k6/http';
import { sleep, check } from 'k6';

// Define las opciones de tu prueba de carga
// Puedes ajustar vus (usuarios virtuales) y duration (duración de la prueba)
export let options = {
  vus: 10, // 10 usuarios virtuales concurrentes
  duration: '30s', // Duración de la prueba de 30 segundos
  // Puedes añadir thresholds para definir criterios de éxito/fallo
  thresholds: {
     http_req_failed: ['rate<0.01'], // Menos del 1% de peticiones fallidas
     http_req_duration: ['p(95)<2000'], // El 95% de las peticiones deben ser menores a 2000ms
  },
};

// URL base de tu aplicación
const BASE_URL = 'http://localhost:8080';

// Parámetros para los endpoints
const CONCAT_COUNT = 50000; // Mayor count para ver mejor la diferencia
const LIST_COUNT = 500000; // Mayor count para ver el uso de memoria
const LEAK_COUNT_PER_CALL = 1000; // Objetos a añadir por llamada a /simular-fuga

/**
 * Función para probar el endpoint de concatenación ineficiente.
 */
function testInefficientConcat() {
  const url = `${BASE_URL}/concat-ineficiente?count=${CONCAT_COUNT}`;
  const res = http.get(url);
  check(res, {
    'is status 200 (ineficiente)': (r) => r.status === 200,
  });
  // sleep(1); // Pausa pequeña entre iteraciones si es necesario
}

/**
 * Función para probar el endpoint de concatenación eficiente (StringBuilder).
 */
function testEfficientConcat() {
  const url = `${BASE_URL}/concat-eficiente?count=${CONCAT_COUNT}`;
  const res = http.get(url);
  check(res, {
    'is status 200 (eficiente)': (r) => r.status === 200,
  });
  // sleep(1); // Pausa pequeña entre iteraciones si es necesario
}

/**
 * Función para probar el endpoint de lista con Wrappers (Integer).
 */
function testWrapperList() {
    const url = `${BASE_URL}/wrapper-list?count=${LIST_COUNT}`;
    const res = http.get(url);
    check(res, {
      'is status 200 (wrapper list)': (r) => r.status === 200,
    });
    // sleep(1); // Pausa pequeña
}

/**
 * Función para probar el endpoint de array con primitivos (int).
 */
function testPrimitiveArray() {
    const url = `${BASE_URL}/primitive-array?count=${LIST_COUNT}`;
    const res = http.get(url);
    check(res, {
      'is status 200 (primitive array)': (r) => r.status === 200,
    });
    // sleep(1); // Pausa pequeña
}


/**
 * Función para simular la fuga de memoria.
 * ¡Úsala con precaución y monitorea el uso de memoria de tu app!
 */
function simulateLeak() {
    const url = `${BASE_URL}/simular-fuga?count=${LEAK_COUNT_PER_CALL}`;
    const res = http.get(url);
    check(res, {
      'is status 200 (simular fuga)': (r) => r.status === 200,
    });
    // sleep(1); // Pausa pequeña
}

/**
 * Función para limpiar la lista que simula la fuga.
 * Llama a este endpoint manualmente o en un escenario separado después de simular la fuga.
 */
function clearLeak() {
    const url = `${BASE_URL}/limpiar-fuga`;
    const res = http.get(url);
    check(res, {
      'is status 200 (limpiar fuga)': (r) => r.status === 200,
    });
     // sleep(1); // Pausa pequeña
}


// La función principal que k6 ejecutará por cada VU
export default function () {
  // Descomenta las llamadas a las funciones que quieras probar
  // Puedes ejecutar pruebas separadas para cada escenario para comparar mejor

  console.log('Ejecutando prueba de concatenación ineficiente...');
  testInefficientConcat();
  sleep(2); // Espera un poco antes de la siguiente prueba

  console.log('Ejecutando prueba de concatenación eficiente...');
  testEfficientConcat();
  sleep(2); // Espera un poco

  console.log('Ejecutando prueba de lista con Wrappers...');
  testWrapperList();
  sleep(2); // Espera un poco

  console.log('Ejecutando prueba de array con primitivos...');
  testPrimitiveArray();
  sleep(2); // Espera un poco

  // Para probar la fuga de memoria, descomenta la siguiente línea.
  // ¡Recuerda que esto puede llevar a un OutOfMemoryError si la carga es alta y sostenida!
  // console.log('Simulando fuga de memoria...');
  // simulateLeak();
  // sleep(1); // Pausa corta para intentar causar la fuga más rápido bajo carga

  // Si quieres limpiar la fuga después de una prueba, puedes ejecutar 'clearLeak()'
  // en un script separado o descomentarlo aquí (aunque en una prueba de carga
  // continua la limpieza no mostrará el efecto de la fuga tan claramente).
  // console.log('Limpiando lista con fuga...');
  // clearLeak();
  // sleep(2); // Espera un poco
}

// Para ejecutar escenarios específicos (ej: solo la fuga), puedes usar la configuración 'scenarios'
/*
export let options = {
  scenarios: {
    leak_simulation: {
      executor: 'constant-vus',
      vus: 5,
      duration: '1m',
      exec: 'simulateLeak', // Ejecuta solo la función simulateLeak
    },
    // Puedes añadir otros escenarios aquí
  },
};
*/
