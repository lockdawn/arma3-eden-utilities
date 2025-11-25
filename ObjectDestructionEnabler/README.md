# Destrucción personalizada de objetos — `fnc_objectDestructionEnabler`

Este módulo define una función que permite **habilitar destrucción personalizada** en cualquier objeto del mapa mediante un evento `HandleDamage`.  
Su propósito es que un objeto específico **sea eliminado automáticamente** cuando su nivel de daño supere un umbral configurable.

Funciona en **misiones MP**, tanto en servidor dedicado como en host local, ya que el evento se adjunta localmente al objeto que recibe daño.

---

## Descripción general de la función

`fnc_objectDestructionEnabler` añade un *Event Handler* `"HandleDamage"` al objeto pasado como parámetro.

El comportamiento principal:

1. Detecta daño entrante mediante el EH `"HandleDamage"`.
2. Evalúa el daño total del objeto usando `damage _target`.
3. Si el daño supera el umbral definido:
   - Se define una variable global `DESTROYED_OBJECT = true;`
   - El objeto es **eliminado** con `deleteVehicle`.
4. Devuelve el daño final tal como requiere el EH.

---

## Consideraciones de performance para el servidor

- El EH solo se ejecuta cuando el objeto **recibe daño**, no cada frame.
- El coste computacional es mínimo.
- En MP, si el objeto es propiedad del servidor, el EH corre ahí.
- No genera tráfico de red extra más allá de la sincronización del objeto eliminado.

---

## Pros de incorporar esta función en tu misión

- **Sencilla de integrar**:  
  ```sqf
  [myObject] call fnc_objectDestructionEnabler;
  ```
- Útil para objetivos tácticos o lógicos.
- Eliminación inmediata y fiable.
- Ideal para misiones **MP**.
- Permite activar eventos de misión mediante `DESTROYED_OBJECT`.

---

## Contras de incorporar esta función en tu misión

- El objeto desaparece inmediatamente (sin explosión o animación).
- No permite un estado intermedio de daño.
- El umbral está fijo en el script.
- La variable global puede entrar en conflicto si otro sistema usa el mismo nombre.

---

## Ejemplo de uso

```sqf
[objTerminal, 0.25] call fnc_objectDestructionEnabler;
```

---

## Resumen

`fnc_objectDestructionEnabler` es una función ligera y robusta para dotar objetos de **destrucción inmediata basada en umbral de daño**, ideal para misiones MP con objetivos destructibles.

