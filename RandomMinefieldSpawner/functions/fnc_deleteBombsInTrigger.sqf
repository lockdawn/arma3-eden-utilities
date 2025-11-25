params ["_trg"];
if (!isServer) exitWith {};
if (isNull _trg) exitWith {};

// trabajo asíncrono para no bloquear
[_trg] spawn {
    params ["_t"];
    private _bombs = _t getVariable ["OEA_spawnedBombs", []];

    {
        if (!isNull _x) then {
            // deleteVehicle puede fallar si ya explotó; protegemos con try/catch estilo
            // (SQF no tiene try/catch, así que verificamos alive / notNull)
            deleteVehicle _x;
            sleep 0.01;
        };
    } forEach _bombs;

    _t setVariable ["OEA_spawnedBombs", [], true];
    _t setVariable ["OEA_bombs_spawned_flag", false, true]; // permite respawn futuro
    systemChat format ["[OEA] Eliminadas %1 minas en %2", count _bombs, name _t];
    diag_log format ["OEA: Deleted %1 bombs in %2", count _bombs, name _t];
};