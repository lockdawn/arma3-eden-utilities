# Compilación de Funciones SQF para Arma 3 (Eden Editor)

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

- [`MapZoomMarkers`](./MapZoomMarkers/)
  - Sistema de marcadores dinámicos basados en el nivel de **zoom del mapa del jugador**. Permite mostrar u ocultar marcadores según la distancia visual, reduciendo saturación y resaltando información relevante.

- [`splitIntoPatrolRoles`](./splitIntoPatrolRoles/)
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
