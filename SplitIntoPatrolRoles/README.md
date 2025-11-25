# fnc_splitIntoPatrolRoles — División de grupo en roles de patrulla

Esta función toma un **grupo de IA ya existente** y lo divide en **subgrupos de 2 unidades**, asignando a cada subgrupo un rol específico de patrulla/ocupación dentro de una zona (FOB, base, poblado, etc.).

El reparto de roles se hace en este orden:

1. **1er subgrupo** → Patrulla general (taskPatrol).
2. **2do subgrupo** → Ocupa torres o posiciones elevadas.
3. **3er subgrupo** → Ronda edificios alrededor de la zona.
4. **4to subgrupo** → Permanece en interiores/pasillos.
5. **Resto de subgrupos** → Patrulla normal.

Al terminar:

- Se crean los subgrupos con sus respectivas órdenes.
- El grupo original se elimina.
- La función devuelve un array con los subgrupos generados.

Pensado para misiones **multijugador (MP)** en **servidor dedicado**, donde la IA es controlada por el servidor o un headless client.

---

## Descripción general de lo que hace esta función

En resumen, `fnc_splitIntoPatrolRoles`:

1. **Recibe como parámetros**:
   - `0: GROUP` → Grupo principal ya existente (por ejemplo, `ia_01`).
   - `1: ARRAY` → Posición `[x, y, z]` que representa el centro de la zona (FOB, base, poblado).
   - `2: NUMBER` → Radio de trabajo, usado como referencia para:
     - Buscar edificios/torres relevantes.
     - Definir el área de patrulla.

2. **Divide el grupo en parejas (subgrupos de 2)**  
   Toma las unidades del grupo principal y las organiza en subgrupos de 2.  
   Cada subgrupo obtiene su propio líder y su propio contexto de órdenes.

3. **Asigna roles según el índice del subgrupo**  
   Usando un índice interno, asigna a cada subgrupo una tarea diferente:
   - Patrullar la zona con una ruta generada alrededor del centro.
   - Buscar y ocupar torres/posiciones elevadas dentro del radio.
   - Moverse alrededor de edificios o estructuras cercanas.
   - Permanecer en interiores/pasillos como “garrison” estático.
   - El resto se comporta como patrulla estándar.

4. **Limpia el grupo original y devuelve los subgrupos**  
   Una vez divididas las unidades:
   - El grupo principal se elimina para evitar duplicidad de mandos.
   - Se devuelve un array de subgrupos, por si se necesita guardar referencia a ellos para lógica adicional (refuerzos, cambio de comportamiento, etc.).

El objetivo de la función es **tomar un grupo genérico** de IA y **convertirlo rápidamente en un despliegue variado y orgánico** dentro de una misma zona, sin tener que colocar y configurar cada patrulla/torre/interior a mano.

---

## Consideraciones de performance para el servidor

- **Ejecución recomendada en servidor/HC**  
  La lógica que crea subgrupos, asigna waypoints y decide tareas debe correrse en el servidor dedicado o en un headless client, ya que:
  - Los grupos y waypoints de IA son propiedad del servidor.
  - Evitas desincronización entre clientes.

- **Coste principal: creación de subgrupos y búsqueda de posiciones**  
  El coste de la función se concentra en:
  - Divide el grupo en subgrupos de 2.
  - Asignar tareas tipo patrulla (p.ej. `BIS_fnc_taskPatrol`).
  - Buscar edificios/torres/interiores dentro del radio definido.

- **Impacto realista en una misión MP**  
  - Llamar a la función **puntualmente** (por ejemplo, una vez al inicio de la misión o al activar un área) tiene un impacto bajo en el servidor.
  - El coste total depende de:
    - Tamaño del grupo original (más unidades = más subgrupos).
    - Radio de trabajo (radios muy grandes pueden implicar más búsquedas de edificios/torres).
  - Una vez creados los subgrupos y waypoints, el resto del consumo es el habitual de la IA de Arma 3 (pathfinding, decisiones, etc.).

- **Buenas prácticas para performance**  
  - Evita llamar a la función en bucles o de forma muy frecuente: úsala como **acción puntual** por evento o trigger.
  - Mantén radios de trabajo razonables (no usar valores absurdamente grandes si no es necesario).
  - Usa esta función combinada con **Dynamic Simulation** o sistemas similares para que la IA se “duerma” cuando no haya jugadores cerca.

---

## Pros de incorporar esta función en tu misión

- ✅ **Gran variedad de comportamiento con muy poca configuración**  
  Con un solo grupo de IA y una llamada a la función, obtienes:
  - Patrullas externas.
  - Guardias en torres.
  - Unidades rondando edificios.
  - Soldados en interiores/pasillos.

- ✅ **Ahorro de tiempo en el Eden Editor**  
  En lugar de crear manualmente varios grupos, waypoints y comportamientos, solo colocas:
  - Un grupo de IA.
  - Un trigger o script con la llamada:
    ```sqf
    [ia_01, [1609.61, 3300.1, 0], 200] call fnc_splitIntoPatrolRoles;
    ```
  Y dejas que la función haga el resto.

- ✅ **Mayor sensación de “vida” en la zona**  
  Al tener IA realizando diferentes funciones (torres, interiores, patrulla externa), la zona se siente:
  - Más defendida.
  - Más orgánica y dinámica.
  - Más impredecible para los jugadores.

- ✅ **Escalable para misiones MP**  
  - Puedes usar la misma función en varias FOBs/zonas.
  - Permite reutilizar la lógica en múltiples misiones con solo cambiar grupo, posición y radio.

- ✅ **Compatible con otros sistemas que controlen IA**  
  Mientras se respete que esta función es la que inicialmente crea y distribuye los subgrupos, puedes:
  - Aplicar estados de combate, comportamiento, skill, etc. sobre los subgrupos devueltos.
  - Integrarla con sistemas de refuerzos, QRF, o scripts que alteren el comportamiento más adelante.

---

## Contras de incorporar esta función en tu misión

- ❌ **Menor control fino sobre cada unidad**  
  - La función toma decisiones automáticas sobre quién patrulla, quién va a torres, quién entra a interiores, etc.
  - Si necesitas control absoluto (unidad por unidad, posición exacta por posición exacta), puede que prefieras configurar patrullas y guarniciones manualmente.

- ❌ **Dependencia de la geometría del mapa**  
  - La utilidad de los roles (torres, edificios, interiores) depende de que:
    - Existan suficientes edificios/torres/interiores dentro del radio.
    - La geometría del mapa esté bien definida para pathfinding.
  - En mapas muy abiertos o con mala definición de edificios, algunos subgrupos podrían quedar con un comportamiento menos interesante.

- ❌ **Posibles resultados “no perfectos” en situaciones extremas**  
  - Con grupos muy pequeños (por ejemplo, 2 o 3 unidades), el reparto de roles puede quedarse corto (no hay suficientes subgrupos para todos los roles).
  - Con grupos muy grandes, se pueden generar muchas parejas patrullando o intentando ocupar edificios, lo que a veces puede verse algo caótico si el diseño de la zona no acompaña.

- ❌ **Necesita coherencia con otros scripts de IA**  
  - Si tienes otros sistemas que:
    - Teletransportan grupos,
    - Regeneran waypoints,
    - O reasignan grupos de forma agresiva,
    
    podrías sobrescribir o romper la lógica generada por `fnc_splitIntoPatrolRoles`.
  - Es recomendable documentar en tu misión que **ese grupo se gestiona por esta función** y, si lo vas a tocar luego, hacerlo sobre los **subgrupos devueltos** por la función y no sobre el grupo original (que se elimina).

---

> **Resumen**:  
> `fnc_splitIntoPatrolRoles` es una herramienta muy útil para misiones MP donde quieres que un solo grupo de IA se despliegue de forma variada y semi-automática dentro de una zona. Aporta mucha “vida” y defensa orgánica con un impacto razonable en el servidor, siempre que se use de forma puntual y con parámetros coherentes con el diseño del escenario.
