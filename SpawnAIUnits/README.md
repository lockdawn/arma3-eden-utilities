
# AI Unit Spawner (FEL)

## 📌 Descripción
La función `FEL_fnc_spawnAIUnits` permite generar unidades de IA de manera dinámica en Arma 3, recorriendo un arreglo de clases hasta alcanzar un número total definido. Está diseñada para entornos multijugador en servidor dedicado y soporta ejecución controlada mediante triggers.

---

## ⚙️ Características
- Spawneo progresivo de IA (delay de 0.5s entre unidades)
- Reutilización del array hasta completar el total requerido
- Compatible con servidor dedicado (server-side execution)
- Soporte para cualquier bando (west, east, resistance, civilian)
- Fácil integración con triggers del editor

---

## 📂 Estructura de Archivos

Coloca el archivo en:

    <mission_root>\functions\fnc_spawnAIUnits.sqf

---

## 🧩 Registro en description.ext

Agrega lo siguiente en tu `description.ext`:

class CfgFunctions {
    class FEL {
        class Spawn {
            class spawnAIUnits {
                file = "functions\fnc_spawnAIUnits.sqf";
            };
        };
    };
};

---

## 📥 Parámetros

La función recibe los siguientes parámetros:

0: ARRAY   - Clases de unidades a spawnear  
1: SCALAR  - Cantidad total de IA a generar  
2: SIDE    - Bando del grupo (west, east, resistance, civilian)  
3: ARRAY   - Posición de spawn [x,y,z]  

---

## 🚀 Uso desde Trigger

En el campo **On Activation** del trigger:

if (isServer) then {
    [
        ["O_Soldier_F","O_Soldier_LAT_F","O_Soldier_AR_F"],
        10,
        east,
        getPosATL thisTrigger
    ] spawn FEL_fnc_spawnAIUnits;
};

---

## 🎯 Configuración del Trigger

### Tipo de Trigger
- Activation: BLUFOR / ANY PLAYER (según necesidad)
- Activation Type: Present
- Repeatable: Opcional

### Recomendaciones
- Tamaño acorde al área de operación
- Ubicar en zona donde deseas generar IA
- Usar `thisTrigger` para obtener posición dinámica

---

## 🔁 Comportamiento de Spawn

Ejemplo:

Clases:
["O_Soldier_F","O_Soldier_LAT_F","O_medic_F"]

Total:
8

Resultado:
- Se recorren las clases en orden
- Se repite el array hasta alcanzar el total
- Delay de 0.5s entre cada unidad

---

## ⚠️ Consideraciones

- Ejecutar SIEMPRE en servidor (`isServer`)
- Evitar múltiples triggers simultáneos sin control
- Mantener arrays de clases válidos
- El grupo se elimina automáticamente si queda vacío

---

## 🧪 Debug

Agregar al inicio del archivo:

diag_log "[FEL] spawnAIUnits ejecutada";
systemChat "spawnAIUnits ejecutada";

---

## 📎 Ejemplo Completo

[
    ["O_Soldier_F","O_Soldier_LAT_F"],
    12,
    east,
    [1000,1000,0]
] spawn FEL_fnc_spawnAIUnits;

---

## 🧠 Notas Finales

Esta función está diseñada para escenarios dinámicos como:
- Misiones zombie
- Oleadas de enemigos
- Eventos dinámicos controlados por triggers

Permite mantener control total sobre cantidad, tipo y ubicación de unidades.
