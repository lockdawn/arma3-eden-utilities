# Minas dinámicas por trigger — `fnc_spawnBombsInTrigger` + `fnc_deleteBombsInTrigger`

Este módulo define **dos funciones complementarias** para gestionar campos minados dinámicos usando **triggers** en misiones **multijugador (MP) en servidor dedicado**:

- **`fnc_spawnBombsInTrigger`** → se llama desde **On Activation**  
  Crea minas de forma aleatoria dentro del área del trigger y guarda una referencia a todas ellas.

- **`fnc_deleteBombsInTrigger`** → se llama desde **On Deactivation**  
  Elimina todas las minas generadas previamente por el mismo trigger.

La idea es que **el propio trigger controla “su” campo minado**:  
cuando se activa, se minan los alrededores; cuando se desactiva, el área se limpia.

> Nota: Ambas funciones están pensadas para ejecutarse en **servidor** (o headless client) en misiones MP.

---

## Descripción general de lo que hacen estas funciones

### `fnc_spawnBombsInTrigger` (On Activation)

En resumen, esta función:

1. **Recibe**:
   - El trigger desde el cual se está llamando (por ejemplo `thisTrigger`).
   - El número máximo de minas que se desea generar.

2. **Valida y controla el re-uso**:
   - Comprueba que la ejecución se haga en servidor.
   - Ignora la llamada si el trigger ya fue minado antes y todavía tiene minas asociadas (evita duplicar minas sin querer).

3. **Genera minas dentro del área del trigger**:
   - Calcula la posición y el área (radio/forma/orientación) del trigger.
   - Escoge posiciones aleatorias dentro de dicha área (normalmente simulando una elipse/rectángulo rotado).
   - Evita colocar minas demasiado cerca de jugadores vivos (para evitar “kills baratos” al activarse el trigger).
   - Selecciona de forma aleatoria la clase de mina desde una lista predefinida (por ejemplo `OEA_BOMB_CLASSES`) y la crea.

4. **Registra las minas**:
   - Guarda en una variable del propio trigger (por ejemplo `spawnedBombs` o similar) el array de minas creadas.
   - Marca el trigger como “minado” para saber que ya tiene un lote activo.

### `fnc_deleteBombsInTrigger` (On Deactivation)

Esta función:

1. **Recibe**:
   - El trigger desde el que se llama (el mismo que se usó para crear las minas).

2. **Recupera las minas asociadas al trigger**:
   - Obtiene el array de minas guardado en la variable del trigger.

3. **Elimina las minas generadas**:
   - Recorre el array de minas.
   - Para cada mina válida, hace `deleteVehicle` (normalmente con pequeños `sleep` entre cada una para repartir la carga).

4. **Resetea el estado del trigger**:
   - Limpia el array de minas asociadas.
   - Libera la “bandera” que indica que el trigger está minado, de modo que el mismo trigger puede volver a usarse después.

---

## Consideraciones de performance para el servidor

- **Ejecución en servidor / HC**  
  Ambas funciones están diseñadas para ejecutarse solo en servidor (o en un headless client si las rediriges allí).  
  Esto garantiza que:
  - La lógica pesada (crear/borrar objetos, gestionar arrays, etc.) se hace una sola vez.
  - La sincronización de las minas hacia los clientes se realiza mediante el motor de Arma 3.

- **Trabajo asíncrono y escalonado**  
  La creación y eliminación de minas suele hacerse en un hilo separado (`spawn`) y con **pequeños `sleep`**:
  - Evita picos de CPU por crear o borrar muchas minas de golpe.
  - Reparte la carga en varios fotogramas del servidor.

- **Impacto condicionado por cantidad y número de triggers**  
  El coste total depende de:
  - Cuántas minas generes por trigger.
  - Cuántos triggers se activen al mismo tiempo.
  - La frecuencia con la que se activan/desactivan (no es lo mismo un evento aislado que uno que se repite cada pocos segundos).

- **Chequeo de jugadores cercanos**  
  El filtro para evitar minas muy cerca de jugadores revisa `allPlayers` en cada intento de creación:
  - Es un coste pequeño pero existente.
  - Se compensa con el límite de intentos y con la ejecución puntual (sólo al activarse el trigger).

En resumen:  
Usadas con valores razonables (decenas de minas, triggers activados de forma puntual), el impacto en el servidor **es moderado y totalmente asumible** para misiones MP.

---

## Pros de incorporar estas funciones en tu misión

- ✅ **Minado dinámico totalmente vinculado a triggers**  
  - Al entrar o activarse una zona: se siembra de minas.
  - Al salir o desactivarse: se limpia automáticamente.
  - Muy útil para fases de misión, objetivos que cambian o zonas que solo deben estar minadas mientras se cumple una condición.

- ✅ **Ahorro de tiempo en el editor**  
  En vez de colocar manualmente decenas de minas:
  - Solo defines el área con un trigger.
  - En **On Activation** pones algo como:
    ```sqf
    [thisTrigger, 20] call fnc_spawnBombsInTrigger;
    ```
  - En **On Deactivation**:
    ```sqf
    [thisTrigger] call fnc_deleteBombsInTrigger;
    ```
  Y listo.

- ✅ **Control centralizado por trigger**  
  Cada trigger:
  - Sabe qué minas generó (las guarda en una variable).
  - Sabe cuándo crearlas y cuándo destruirlas (On Activation / On Deactivation).
  - No depende de scripts externos complicados para limpiar.

- ✅ **Consistencia entre creación y eliminación**  
  Como las dos funciones están diseñadas para trabajar juntas:
  - Todo lo que se crea con `fnc_spawnBombsInTrigger` se elimina con `fnc_deleteBombsInTrigger`.
  - Se evita dejar “basura” en el mapa (minas huérfanas).

- ✅ **Adaptable a muchos tipos de misión MP**  
  - Emboscadas dinámicas.
  - Zonas de paso peligrosas solo durante cierta fase.
  - “Trampas” activables por script o por presencia enemiga.

---

## Contras de incorporar estas funciones en tu misión

- ❌ **Menor control exacto de la posición de cada mina**  
  - Las minas se colocan de forma aleatoria dentro del área del trigger.
  - Si necesitas un patrón ultra específico (por ejemplo, minas alineadas milimétricamente en una carretera), quizá prefieras colocarlas manualmente.

- ❌ **Dependencia de una lista de clases de minas**  
  - Las funciones requieren que exista un array con las clases de minas válidas.
  - Si ese array no está bien definido (clases mal escritas, mods desactivados, etc.), no se crearán minas o generarán errores.

- ❌ **Impacto acumulado si se abusa**  
  - Si pones muchos triggers que generan muchísimas minas, el servidor puede:
    - Cargar más trabajo de simulación (física, explosiones, sensores de IA).
    - Tardar más en limpiar cuando se desactiven.
  - Requiere cierto sentido común en la cantidad máxima de minas y la cantidad de zonas activas.

- ❌ **Necesidad de coherencia con otros scripts de limpieza**  
  - Si otros scripts de la misión eliminan objetos de forma masiva (`deleteVehicle` en áreas grandes, “garbage collectors”, etc.), pueden borrar minas sin pasar por `fnc_deleteBombsInTrigger`.
  - Eso puede dejar desactualizado el array de minas guardado en el trigger (cree que hay minas, pero ya no existen).

- ❌ **Dependencia de la forma del trigger**  
  - La distribución del minado depende completamente del área/orientación del trigger.
  - Triggers mal colocados o demasiado pequeños/grandes pueden producir campos minados poco útiles (minas lejos de la ruta real de los jugadores, por ejemplo).

---

> **Resumen**  
> `fnc_spawnBombsInTrigger` y `fnc_deleteBombsInTrigger` forman un par de funciones diseñado específicamente para **minar y desminar zonas usando triggers** en misiones MP. Ofrecen una forma flexible y reutilizable de añadir campos minados dinámicos con impacto controlado en el servidor, a cambio de ceder algo de control milimétrico sobre la posición de cada mina y de mantener una configuración coherente de clases de minas y scripts de limpieza.
