# ✈️ Ambient Flyby's Function para Arma 3

Este script permite generar **sobrevuelos ambientales de aeronaves de
forma dinámica y aleatoria en todo el mapa**, creando inmersión y
sensación de actividad sin necesidad de colocar unidades manualmente.

El sistema ejecuta un bucle continuo que genera aeronaves que cruzan el
mapa a intervalos aleatorios, simulando tráfico aéreo militar (CAS,
transporte, patrullas, etc.).

------------------------------------------------------------------------

## 📌 Descripción general

Esta función utiliza `BIS_fnc_ambientFlyBy` para generar aeronaves que:

-   Aparecen fuera del área central del mapa\
-   Cruzan el mapa en línea recta\
-   Desaparecen automáticamente al finalizar su recorrido\
-   Se generan en intervalos aleatorios

------------------------------------------------------------------------

## ⚙️ Cómo funciona

### 🔁 Bucle principal

``` sqf
[] spawn {
    while { true } do {
```

-   Ejecuta el sistema **de forma indefinida**
-   Usa `spawn` para correr en paralelo sin bloquear otros scripts

------------------------------------------------------------------------

### 🎲 Selección aleatoria de aeronaves

``` sqf
_type = [
    [150, "FULL", "B_Plane_CAS_01_F"],
    [40, "NORMAL", "B_Heli_Light_01_F"],
    [60, "NORMAL", "B_Heli_Transport_01_F"]
] call BIS_fnc_selectRandom;
```

------------------------------------------------------------------------

### 📍 Cálculo de trayectoria

``` sqf
_distance   = 5000;
_direction  = random 360;
_position   = getMarkerPos "BIS_bootcampCenter";

_positionStart  = [_position, _distance, _direction] call BIS_fnc_relPos;
_positionEnd    = [_position, _distance, _direction + 180] call BIS_fnc_relPos;
```

------------------------------------------------------------------------

### ✈️ Ejecución

``` sqf
[_positionStart, _positionEnd, _height, _speed, _class, WEST] call BIS_fnc_ambientFlyBy;
```

------------------------------------------------------------------------

### ⏱️ Delay

``` sqf
sleep 300 + random 150;
```

------------------------------------------------------------------------

## 🧠 Uso en Eden Editor

1.  Crear archivo: `ambientFlybys.sqf`\
2.  Crear marker: `BIS_bootcampCenter`\
3.  Ejecutar en init.sqf:

``` sqf
[] execVM "ambientFlybys.sqf";
```

------------------------------------------------------------------------

## 🎯 Resultado

-   Tráfico aéreo dinámico\
-   Mayor inmersión\
-   Sistema ligero y automático
