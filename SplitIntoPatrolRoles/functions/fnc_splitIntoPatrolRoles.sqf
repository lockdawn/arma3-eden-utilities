/*
    Función: fnc_splitIntoPatrolRoles
    Divide un grupo en subgrupos de 2 y asigna roles:

    - 1er subgrupo: patrulla
    - 2do subgrupo: ocupa torres
    - 3er subgrupo: ronda edificios
    - 4to subgrupo: se queda en interiores/pasillos
    - resto: patrulla

    Parámetros:
    0: GROUP  - Grupo principal ya existente (ej: ia_01)
    1: ARRAY  - Posición [x,y,z] centro de la zona FOB
    2: NUMBER - Radio de trabajo (detección de edificios/torres y patrullas)

    Ejemplo:
      [ia_01, [1609.61, 3300.1, 0], 200] call fnc_splitIntoPatrolRoles;
*/

fnc_splitIntoPatrolRoles = {
	
    params [
        ["_mainGrp", grpNull, [grpNull]],
        ["_pos", [0,0,0], [[]]],
        ["_radius", 100, [0]]
    ];

    if (!isServer) exitWith {};

    private _units     = units _mainGrp;
    private _side      = side _mainGrp;
    private _chunkSize = 2;
    private _subgroups = [];

    // Buscar torres y edificios alrededor del FOB
    private _towers = nearestObjects [
        _pos,
        [
            "Land_Airport_02_controlTower_F",
			"Land_Cargo_Patrol_V3_F",
			"Land_Cargo_Tower_V3_F"
        ],
        _radius
    ];

    private _houses = nearestObjects [
        _pos,
        [
			"Land_BagBunker_Large_F",
			"Land_MilOffices_V1_F",
            "Land_u_Barracks_V2_F",
			"Land_Medevac_HQ_V1_F",
			"Land_Cargo_HQ_V3_F",
			"Land_Hangar_F",
			"Land_Radar_F"
		],
        _radius
    ];

    private _subIndex = 0;

    for "_i" from 0 to (count _units - 1) step _chunkSize do {

        private _slice = _units select [_i, _chunkSize];
        if (_slice isEqualTo []) then { continue };

        private _newGrp = createGroup _side;
        _subgroups pushBack _newGrp;

        {
            [_x] joinSilent _newGrp;
        } forEach _slice;

        private _leader = leader _newGrp;

        switch (_subIndex) do {

            // 0: patrulla general
            case 0: {
                [group _leader, _pos, _radius] call BIS_fnc_taskPatrol;
            };

            // 1: ocupa torres
            case 1: {
                {
                    if (count _towers > 0) then {
                        private _tower   = selectRandom _towers;
                        private _bPosArr = _tower buildingPos -1;
                        if (count _bPosArr > 0) then {
                            private _bPos = selectRandom _bPosArr;
                            _x setPosATL _bPos;
                            _x setUnitPos "UP";
                            _x disableAI "PATH";   // se quedan defendiendo
                        };
                    };
                } forEach units _newGrp;
            };

            // 2: ronda edificios (patrulla centrada en edificios)
            case 2: {
                private _center = _pos;
                if (count _houses > 0) then {
                    _center = getPosATL (selectRandom _houses);
                };
                [group _leader, _center, _radius / 2] call BIS_fnc_taskPatrol;
            };

            // 3: interiores / pasillos
            case 3: {
                {
                    if (count _houses > 0) then {
                        private _house   = selectRandom _houses;
                        private _bPosArr = _house buildingPos -1;
                        if (count _bPosArr > 0) then {
                            private _bPos = selectRandom _bPosArr;
                            _x setPosATL _bPos;
                            _x setUnitPos "MIDDLE";  // interior/cobertura
                            _x disableAI "PATH";     // estático en pasillo/sala
                        };
                    };
                } forEach units _newGrp;
            };

            // resto: patrulla normal
            default {
                [group _leader, _pos, _radius] call BIS_fnc_taskPatrol;
            };
        };

        _subIndex = _subIndex + 1;
    };

    deleteGroup _mainGrp;

    _subgroups
};
