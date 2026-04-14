
# AI Unit Spawner

## 📌 Descripción
La función `FEL_fnc_spawnAIUnits` permite generar unidades de IA de manera dinámica en Arma 3, recorriendo una lista de unidades hasta alcanzar un número total definido. 

Está diseñada para entornos multijugador en servidor dedicado y soporta ejecución controlada mediante triggers, lo que la hace ideal para escenarios dinámicos como misiones zombie, oleadas de enemigos o eventos activados durante la partida. 

Proporciona control total sobre la cantidad, tipo de unidad y ubicación de las unidades generadas, facilitando la creación de situaciones tácticas adaptables y escalables.

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
```
<mission_root>\functions\fnc_spawnAIUnits.sqf
```
---

## 🧩 Registro en description.ext

Agrega lo siguiente en tu `description.ext`:

```
class CfgFunctions {
    class FEL {
        class Spawn {
            class spawnAIUnits {
                file = "functions\fnc_spawnAIUnits.sqf";
            };
        };
    };
};
```
---

## 📥 Parámetros

La función recibe los siguientes parámetros desde el trigger:

- 0: ARRAY   - Clases de unidades a spawnear  
- 1: SCALAR  - Cantidad total de IA a generar  
- 2: SIDE    - Bando del grupo (west, east, resistance, civilian)  
- 3: ARRAY   - Posición de spawn [x,y,z]  

---

## 🎯 Configuración del Trigger

### Tipo de Trigger
- Activation: BLUFOR / ANY PLAYER (según necesidad)
- Activation Type: Present
- Repeatable: No
- Server Only: Yes

### On Activation

En el campo **On Activation** del trigger:

```
[
	["O_Soldier_F","O_Soldier_LAT_F","O_Soldier_AR_F"],
	10,
	east,
	getPosATL thisTrigger
] spawn FEL_fnc_spawnAIUnits;
```

---

## 🔁 Comportamiento de Spawn

Ejemplo:
- Clases: ["O_Soldier_F","O_Soldier_LAT_F","O_medic_F"]
- Total: 8

Resultado:
- Se recorren las clases de izquierda a derecha.
- Se repite el arreglo hasta alcanzar el total de 8 unidades creadas.
- Delay de 0.5s entre cada unidad creada.

---

## ⚠️ Consideraciones

- Ejecutar SIEMPRE en servidor (`isServer`)
- Evitar múltiples triggers simultáneos sin control
- Mantener arrays de clases válidos
- El grupo se elimina automáticamente si queda vacío
