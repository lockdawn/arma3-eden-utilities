// Si este código no se está ejecutando en el servidor, termina inmediatamente.
// Esto evita que clientes o jugadores ejecuten la función por error.
if (!isServer) exitWith {};

// =============================
//         CONFIGURACIÓN
// =============================

// Lista de aeronaves que pueden aparecer.
// [ALTURA, VELOCIDAD, CLASE]
private _types = [
    [150, "FULL", "B_Plane_CAS_01_F"],
    [40, "NORMAL", "B_Heli_Light_01_F"],
    [60, "NORMAL", "B_Heli_Transport_01_F"],
    [80, "NORMAL", "O_Heli_Light_02_F"]
];

// Si por alguna razón el array de tipos está vacío, la función se detiene.
// Así evitas errores al intentar seleccionar un elemento aleatorio inexistente.
if (_types isEqualTo []) exitWith {
    // Escribe un mensaje en el log RPT del servidor para facilitar debugging.
    diag_log "[AmbientFlybys] ERROR: El array _types está vacío. No hay aeronaves configuradas.";
};

// =============================
//     VALIDACIÓN DE MARKER
// =============================

// Obtiene la posición del marker llamado BIS_mapCenter.
// Este marker debe colocarse manualmente en el mapa, idealmente cerca del centro.
private _centerPos = getMarkerPos "BIS_mapCenter";

// Si el marker no existe, getMarkerPos devolverá [0,0,0].
// En ese caso, la función se detiene para evitar comportamientos incorrectos.
if (_centerPos isEqualTo [0,0,0]) exitWith {

    // Mensaje de error que se enviará al log del servidor.
    private _msg = "[AmbientFlybys] ERROR: No se encontró el marker 'BIS_mapCenter'. Coloca un marker invisible en el centro del mapa o en el área de operaciones.";

    // Registrar el error en el RPT del servidor.
    diag_log _msg;

    // Si estás probando la misión en el editor, muestra un hint en pantalla.
    // Esto sirve como recordatorio inmediato para el editor de misión.
    if (is3DENPreview) then {
        hint _msg;
    };
};

// =============================
//       BUCLE PRINCIPAL
// =============================

// Bucle infinito: seguirá generando sobrevuelos durante toda la misión.
while {true} do {

    // Selecciona aleatoriamente una de las configuraciones de la lista de aeronaves.
    private _type = _types call BIS_fnc_selectRandom;

    // Extrae la altura desde el índice 0 del sub-array seleccionado.
    private _height = _type select 0;

    // Extrae la velocidad ("FULL" o "NORMAL") desde el índice 1.
    private _speed  = _type select 1;

    // Extrae la clase del vehículo desde el índice 2.
    private _class  = _type select 2;

    // Genera una dirección aleatoria entre 0 y 360 grados.
    // Esto permite que cada sobrevuelo cruce el mapa desde un ángulo distinto.
    private _direction = random 360;

    // Define qué tan lejos del centro estarán el punto inicial y final del flyby.
    // Usar worldSize * 0.5 ayuda a que el spawn/despawn ocurra lejos de la zona visible.
	// Nunca menor a 6,000 m y nunca mayor a 12,000 m
    private _distance = (worldSize * 0.5) min 12000 max 6000;

    // Calcula la posición inicial del sobrevuelo.
    // Parte desde el centro del mapa, alejándose _distance metros en la dirección aleatoria.
    private _positionStart = [_centerPos, _distance, _direction] call BIS_fnc_relPos;

    // Calcula la posición final del sobrevuelo.
    // Usa la dirección opuesta (+180 grados), para que la aeronave cruce todo el mapa.
    private _positionEnd = [_centerPos, _distance, _direction + 180] call BIS_fnc_relPos;

    // Llama a la función nativa de Arma 3 que crea el flyby ambiental.
    // Parámetros:
    // 1. Posición inicial
    // 2. Posición final
    // 3. Altura
    // 4. Velocidad
    // 5. Classname de la aeronave
    // 6. Bando de la tripulación
    [_positionStart, _positionEnd, _height, _speed, _class, WEST] call BIS_fnc_ambientFlyBy;

    // Espera entre 300 y 450 segundos antes de generar el siguiente sobrevuelo.
    // Esto evita exceso de actividad y ayuda a mantener buen performance.
    sleep (300 + random 150);
};