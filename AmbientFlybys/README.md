# ✈️ Ambient Flyby's Function para Arma 3

Este script permite generar **sobrevuelos ambientales de aeronaves de forma dinámica y aleatoria en todo el mapa**, creando inmersión y sensación de actividad sin necesidad de colocar unidades manualmente.

El sistema ejecuta un bucle continuo que genera aeronaves que cruzan el mapa a intervalos aleatorios, simulando tráfico aéreo militar (CAS, transporte, patrullas, etc.).

---

## 📌 Descripción general

Esta función utiliza `BIS_fnc_ambientFlyBy` para generar aeronaves que:

- Aparecen fuera del área central del mapa  
- Cruzan el mapa en línea recta  
- Desaparecen automáticamente al finalizar su recorrido  
- Se generan en intervalos aleatorios  

---

## ⚙️ Cómo funciona

### 🔁 Bucle principal

```sqf
[] spawn {
	while { true } do {
Ejecuta el sistema de forma indefinida
Usa spawn para correr en paralelo sin bloquear otros scripts
🎲 Selección aleatoria de aeronaves
_type = [
	[150, "FULL", "B_Plane_CAS_01_F"],
	[40, "NORMAL", "B_Heli_Light_01_F"],
	[60, "NORMAL", "B_Heli_Transport_01_F"]
] call BIS_fnc_selectRandom;

Cada entrada tiene la siguiente estructura:

[ALTURA, VELOCIDAD, CLASE]
Parámetro	Descripción
Altura	Altitud de vuelo
Velocidad	"FULL" o "NORMAL"
Clase	Classname del vehículo
📦 Extracción de parámetros
_height	= _type select 0;
_speed	= _type select 1;
_class	= _type select 2;
📍 Cálculo de trayectoria
_distance	= 5000;
_direction	= random 360;
_position	= getMarkerPos "BIS_bootcampCenter";

_positionStart	= [_position, _distance, _direction] call BIS_fnc_relPos;
_positionEnd	= [_position, _distance, _direction + 180] call BIS_fnc_relPos;
Explicación:
Se usa un marker central (BIS_bootcampCenter)
Se genera una dirección aleatoria (0–360°)
Se calculan dos puntos:
Inicio (fuera del mapa)
Fin (lado opuesto)

👉 Resultado: la aeronave cruza el mapa completamente

✈️ Ejecución del flyby
[_positionStart, _positionEnd, _height, _speed, _class, WEST] call BIS_fnc_ambientFlyBy;
Parámetro	Descripción
Start	Posición inicial
End	Posición final
Height	Altura
Speed	Velocidad
Class	Tipo de aeronave
Side	Bando
⏱️ Delay entre sobrevuelos
sleep 300 + random 150;
Tiempo base: 300 segundos (5 min)
Variación: +0 a 150 segundos

👉 Resultado: sobrevuelos cada 5 a 7.5 minutos

🧠 Qué hace realmente el script

Cada vez que se ejecuta:

✔️ Selecciona una aeronave aleatoria
✔️ La crea desde cero (no existe en el editor)
✔️ Genera tripulación automáticamente
✔️ La hace volar de un punto a otro
✔️ La elimina automáticamente al terminar

⚠️ Importante

Este sistema es ambiental, no táctico:

❌ No patrulla
❌ No combate
❌ No responde a jugadores
✅ Solo genera tráfico aéreo para inmersión
🧠 Cómo usarlo en Eden Editor
1️⃣ Crear el script

Guarda el archivo como:

ambientFlybys.sqf

Dentro de tu misión.

2️⃣ Crear el marker central

En Eden Editor:

Crear un marker en el mapa
Nombre EXACTO:
BIS_bootcampCenter

⚠️ Obligatorio

3️⃣ Ejecutar el script
Opción recomendada (init.sqf)
[] execVM "ambientFlybys.sqf";
Opción alternativa (Trigger)

En "On Activation":

[] execVM "ambientFlybys.sqf";
🔧 Personalización
➤ Agregar más aeronaves
_type = [
	[150, "FULL", "B_Plane_CAS_01_F"],
	[40, "NORMAL", "B_Heli_Light_01_F"],
	[60, "NORMAL", "B_Heli_Transport_01_F"],
	[80, "NORMAL", "O_Heli_Light_02_F"]
] call BIS_fnc_selectRandom;
➤ Cambiar frecuencia
sleep 120 + random 60;
➤ Cambiar distancia
_distance = 8000;
➤ Cambiar bando
WEST
EAST
RESISTANCE
CIVILIAN
⚠️ Consideraciones de rendimiento
No reducir demasiado el sleep
Evitar demasiados flybys simultáneos
Ideal para misiones PvE o MILSIM
🎯 Resultado

Con este sistema obtendrás:

Tráfico aéreo dinámico
Mayor inmersión
Ambiente vivo sin carga pesada
🧩 Posibles mejoras
Integración con CfgFunctions
Activación por zonas (triggers)
Diferentes patrones según hora o fase de misión
Mezcla con IA real (CAS / transporte)