/*
    File: functions\fnc_spawnAIUnits.sqf

    Descripción:
    Spawnea IA OPFOR recorriendo un array de clases hasta alcanzar
    el total indicado. Si el total no se alcanza al terminar el array,
    vuelve a recorrerlo desde el inicio.

    Debe ejecutarse con spawn, no con call, porque usa sleep.

    Parámetros:
    0: ARRAY  - Clases de unidades a spawnear
    1: SCALAR - Cantidad total de IA a spawnear
    2: SIDE   - Bando del grupo (west, east, resistance, civilian)
    3: STRING  - Posición centro de spawn [x,y,z] (opcional)

    Ejemplo:
    [
		["O_Soldier_F", "O_Soldier_LAT_F"],
		10,
		east,
		getPosATL thisTrigger
	] spawn FEL_fnc_spawnAILoop;
*/

if (!isServer) exitWith {
    diag_log "[FEL_fnc_spawnAIUnits] Cancelado: solo debe ejecutarse en el servidor.";
};

params [
    ["_unitClasses", [], [[]]],
    ["_totalToSpawn", 0, [0]],
    ["_unitSide", east, [sideUnknown]],
    ["_spawnCenter", [0,0,0], [[]]]
];

if (_unitClasses isEqualTo []) exitWith {
    diag_log "[FEL_fnc_spawnAIUnits] Error: el array de clases está vacío.";
};

if (_totalToSpawn <= 0) exitWith {
    diag_log "[FEL_fnc_spawnAIUnits] Error: la cantidad total a spawnear debe ser mayor a 0.";
};

private _spawnedCount = 0;
private _classIndex = 0;

// Default: OPFOR
private _grp = createGroup [_unitSide, true];

while { _spawnedCount < _totalToSpawn } do {

    private _className = _unitClasses select _classIndex;

    // Busca una posición segura cerca del centro
    private _spawnPos = [_spawnCenter, 0, 8, 2, 0, 0.3, 0] call BIS_fnc_findSafePos;

    // Si BIS_fnc_findSafePos falla, usa la posición central
    if (_spawnPos isEqualTo []) then {
        _spawnPos = +_spawnCenter;
    };

    private _unit = _grp createUnit [_className, _spawnPos, [], 0, "NONE"];

    // Opcional: dirección aleatoria
    _unit setDir (random 360);

    _spawnedCount = _spawnedCount + 1;

    // Avanza al siguiente índice del array
    _classIndex = _classIndex + 1;

    // Si llegó al final, vuelve a empezar desde el primer elemento
    if (_classIndex >= count _unitClasses) then {
        _classIndex = 0;
    };

    sleep 0.5;
};

diag_log format [
    "[FEL_fnc_spawnAIUnits] Spawn completado. Total generado: %1",
    _spawnedCount
];
