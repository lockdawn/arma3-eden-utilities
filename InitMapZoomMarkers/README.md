# Marcadores en el mapa por zoom (FAR / NEAR)

Este módulo añade un sistema de “bandas de zoom” para marcadores del mapa, pensado para misiones multijugador (MP) en servidor dedicado.  
Divide tus marcadores en dos grupos:

- **FAR** – Marcadores que solo se muestran cuando el jugador está con el mapa más alejado.
- **NEAR** – Marcadores que solo se muestran cuando el jugador hace zoom para ver zonas más concretas.

La función:

- Se ejecuta **solo en clientes** (`hasInterface`), por lo que no afecta al servidor dedicado.
- Escucha el evento `MouseZChanged` del mapa (display 12) para detectar cambios de zoom.
- Cambia la visibilidad de los marcadores **de forma local** al cliente usando bandas de zoom (FAR / NEAR).
- Permite configurar fácilmente qué marcadores pertenecen a cada grupo editando los arrays `_marksFar` y `_marksNear` dentro del script.

---

## Descripción general de la función

En resumen, la función:

1. **Clasifica marcadores** en dos listas:
   - `_marksFar`: marcadores “lejanos” (por ejemplo, FOBs, bases principales, objetivos generales).
   - `_marksNear`: marcadores “cercanos” (por ejemplo, sectores, zonas de despliegue, puntos de interés táctico).

2. **Se engancha al mapa del juego**:
   - Cuando el jugador abre el mapa y mueve la rueda del ratón (zoom), el evento `MouseZChanged` se dispara.
   - El script evalúa el nivel de zoom actual y decide si la “banda” activa es **FAR** o **NEAR**.

3. **Aplica la banda de visibilidad**:
   - En función de la banda activa (FAR / NEAR), ajusta la visibilidad (alpha) de los marcadores definidos en cada grupo.
   - La visibilidad se maneja **localmente en el cliente**, por lo que cada jugador ve los marcadores según su propio nivel de zoom.

El resultado:  
Un mapa más limpio y legible, que muestra información “macro” cuando estás alejado y detalles tácticos al acercarte.

---

## Consideraciones de performance (servidor)

- El script comienza con `if (!hasInterface) exitWith {};`, lo que significa:
  - **No se ejecuta en el servidor dedicado.**
  - No se ejecuta en máquinas sin interfaz (headless client sin UI, por ejemplo).
- Toda la lógica corre en **cada cliente**, y la manipulación de marcadores es local:
  - No usa `publicVariable`, ni bucles intensivos en el servidor.
  - No genera tráfico de red adicional.
- El **impacto en el cliente** es muy bajo:
  - Solo actúa cuando el mapa está abierto y el jugador cambia el zoom.
  - El coste es básicamente iterar sobre las listas de marcadores FAR/NEAR y aplicar `setMarkerAlphaLocal` (o equivalente) cuando cambia la banda.

En misiones MP:

- **Carga para el servidor**: prácticamente nula.
- **Escalado**: el coste no aumenta de forma significativa con el número de jugadores, porque la lógica es local para cada cliente.
- El único factor a vigilar es el **número total de marcadores** incluidos en las listas:
  - Si tienes cientos de marcadores en FAR/NEAR y el jugador hace zoom muy rápidamente, se harán más llamadas de actualización, pero sigue siendo manejable en la mayoría de casos.

---

## Pros de incorporar esta función en tu misión

- ✅ **Mapa más limpio y legible**  
  Evita saturar el mapa con iconos. Los jugadores solo ven la información relevante según el nivel de zoom.

- ✅ **Mejor experiencia de usuario en MP**  
  - A nivel “estratégico” (zoom out): se ven FOBs, bases, objetivos generales.
  - A nivel “táctico” (zoom in): se ven sectores, rutas, detalles finos de la operación.

- ✅ **Cero coste en el servidor dedicado**  
  La lógica es 100 % cliente, ideal para servidores MP donde cada ciclo de CPU del servidor cuenta.

- ✅ **Sin tráfico de red extra**  
  Todo es local al cliente, por lo que no agrega sincronización de variables ni spam de mensajes.

- ✅ **Fácil de configurar y extender**  
  - Solo hay que añadir los nombres de los marcadores a los arrays `_marksFar` y `_marksNear`.
  - Es sencillo añadir más marcadores o cambiar su grupo sin modificar la lógica central.

- ✅ **Compatible con cualquier tipo de misión MP**  
  Desde coop pequeñas hasta operaciones grandes con muchos jugadores, mientras se mantenga una cantidad razonable de marcadores.

---

## Contras de incorporar esta función en tu misión

- ❌ **Potenciales conflictos con otros scripts de marcadores**  
  - Si otro script asume que ciertos marcadores siempre están visibles o controla su alpha de forma global, puede haber solapamientos lógicos.
  - Es recomendable centralizar toda la lógica de visibilidad de marcadores que dependan de zoom en este sistema, o documentar claramente qué marcadores están bajo su control.

---

> **Resumen**:  
> Esta función es una muy buena opción para cualquier misión MP que quiera mantener el mapa limpio y manejable, mostrando información a diferentes escalas, con impacto casi nulo en el servidor dedicado y un coste mínimo en el cliente. Solo requiere una buena organización de los marcadores y cierta coordinación con otros scripts que también modifiquen su visibilidad.


