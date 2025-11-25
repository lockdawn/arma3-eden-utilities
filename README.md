# Utilidades en SQF para Arma 3 (Eden Editor)

Este repositorio reúne una colección de **funciones, utilidades y efectos en SQF** diseñados para optimizar y agilizar el proceso de creación de misiones en **Arma 3**, particularmente dentro del **Editor Eden**.

El objetivo principal es poner a disposición de los editores un conjunto de herramientas listas para usar, fáciles de integrar y documentadas de manera clara, con el fin de mejorar la eficiencia y coherencia en el desarrollo de misiones.

---

## Propósito del repositorio

- Proporcionar un **conjunto estructurado de funciones reutilizables** aplicables a distintos escenarios de edición.
- Ofrecer **guía y apoyo** a quienes diseñan misiones, permitiendo integrar lógica, efectos y utilidades sin partir desde cero.
- Mantener una organización que facilite:
  - Ubicar rápidamente cada módulo.
  - Comprender su funcionamiento.
  - Integrarlo adecuadamente en una misión existente.

Cada carpeta del repositorio contiene **una función o módulo independiente**, junto con su documentación específica y ejemplos de uso cuando corresponde.

---

## Índice de módulos

Seleccione cualquiera de las carpetas para acceder a su respectiva documentación:

- [`InitMapZoomMarkers`](./InitMapZoomMarkers/)
  - Sistema de marcadores dinámicos basados en el nivel de **zoom del mapa del jugador**. Permite mostrar u ocultar marcadores según la distancia visual, reduciendo saturación y resaltando información relevante.

- [`ObjectDestructionEnabler`](./ObjectDestructionEnabler/)
  - Función que convierte objetos indestructibles en destructibles, facilitando misiones donde es necesario eliminar objetivos por daño (bombas, granadas, etc) que por defecto no pueden dañarse.
 
- [`RandomMinefieldSpawner`](./RandomMinefieldSpawner/)
  - Sistema que permite generar minas de forma aleatoria dentro del área de un trigger al activarse, y eliminarlas automáticamente al desactivarse.

- [`SplitIntoPatrolRoles`](./SplitIntoPatrolRoles/)
  - Función que distribuye miembros de un grupo de IA en **roles de patrulla** dentro de un área definida. Facilita la generación rápida de comportamientos patrullados sin colocar manualmente cada unidad.

> Nuevos módulos y funciones serán añadidos progresivamente, cada uno con su propia documentación.

---

## Instrucciones de integración en una misión

A continuación se describe el flujo general para integrar cualquiera de las funciones de este repositorio en una misión de Arma 3.

### 1. Copiar el archivo SQF a la carpeta `functions` de la misión

1. En el directorio de la misión (por ejemplo: `MiMision.Altis/`), crear una carpeta llamada `functions` si aún no existe.
2. Copiar el archivo `.sqf` de la función que se desea utilizar dentro de esa carpeta.

Ejemplo:

```text
MiMision.Altis/
|- description.ext
|- initServer.sqf
|- mission.sqm
|- functions/
   |- fnc_splitIntoPatrolRoles.sqf
   # Otros scripts opcionales...
```

### 2. Inicializar la función en `initServer.sqf`

Cada módulo del repositorio incluye un proyecto de ejemplo con la estructura:

```text
|- EjemploFuncion/
   |- initServer.sqf
   |- ejemploFuncion.sqf
```

El archivo `initServer.sqf` del ejemplo contiene la línea o bloque de inicialización que debe copiarse al `initServer.sqf` de la misión.

Esta inicialización garantiza que la función esté cargada y disponible cuando el servidor o host de la misión arranque.

### 3. Llamar a la función dentro de la misión

Una vez inicializada la función, puede ser invocada desde:

- Un trigger.
- El campo Init de un objeto.
- El campo Init de una unidad.
- Otro script.

Ejemplo de llamada para `fnc_splitIntoPatrolRoles`:

```sqf
[ia_01, [1609.61, 3300.1, 0], 200] call fnc_splitIntoPatrolRoles;
```

Donde:

- ia_01 → Grupo de IA que realizará la patrulla.
- [1609, 3300, 0] → Coordenadas del centro del área de patrullaje.
- 100 → Radio del área de patrullaje en metros.

Estructura general de llamada:

```sqf
[GrupoIA, [PosicionCentro], Radio] call NombreDeLaFunción;
```

Cada módulo incluye un README con la explicación detallada de parámetros y ejemplos adicionales.

## Contribuciones

Se aceptan propuestas de mejora, correcciones y nuevos módulos.
Las contribuciones pueden enviarse mediante:

- Issues (para reportar fallos o sugerir funciones)
- Pull Requests (para aportar código directamente)

Se recomienda incluir una breve descripción técnica del cambio propuesto y un ejemplo de uso cuando corresponda.
