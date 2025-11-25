params ["_trg","_num"];
if (!isServer) exitWith {}; // ejecutar solo en server
if (isNull _trg) exitWith {};
//if (!(_num isKindOf "NUMBER") || {_num <= 0}) exitWith {};

// Si ya se spawneó en este trigger, salir
if ((_trg getVariable ["OEA_bombs_spawned_flag", false]) isEqualTo true) exitWith {};
_trg setVariable ["OEA_bombs_spawned_flag", true, true];

// Trabajo asíncrono para no bloquear
[_trg, _num] spawn {
    params ["_t","_max"];

    private _center = getPosATL _t;
    private _area   = triggerArea _t; // [a,b,angle,isRect]
    _area params ["_a","_b","_dir","_isRect"];

    private _cx = _center select 0;
    private _cy = _center select 1;

    private _bombs = [];
    private _attempts = 0;
    private _limitAttempts = _max * 8;

    while { (count _bombs) < _max && { _attempts < _limitAttempts } } do {
        _attempts = _attempts + 1;

        // punto aleatorio dentro de la elipse del trigger (grados)
        private _tang = random 360;
        private _r = sqrt (random 1);
        private _x = _a * _r * (cos _tang);
        private _y = _b * _r * (sin _tang);

        // rotación por ángulo del trigger
        private _rx = (_x * (cos _dir)) - (_y * (sin _dir));
        private _ry = (_x * (sin _dir)) + (_y * (cos _dir));

        private _pos = [_cx + _rx, _cy + _ry, 0];

        // evita crear justo debajo de jugadores
        if ((allPlayers findIf { alive _x && (_x distance2D _pos) < 12 }) != -1) then { sleep 0.01; continue; };

        private _cls = selectRandom OEA_BOMB_CLASSES;
        private _mine = createMine [_cls, _pos, [], 0];

        if (!isNull _mine) then {
            _mine setVariable ["OEA_dynBomb", true, true];
            _bombs pushBack _mine;
            sleep 0.02; // escalona creación
        } else { sleep 0.01; };
    };

    _t setVariable ["OEA_spawnedBombs", _bombs, true];
    // feedback
    systemChat format ["[OEA] Spawned %1 minas en %2 (pedidas: %3)", count _bombs, name _t, _max];
    diag_log format ["OEA: Spawned %1 bombs in %2 (asked %3, attempts %4)", count _bombs, name _t, _max, _attempts];
};