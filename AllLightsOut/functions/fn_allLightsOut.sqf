/*
    fnc_miscript.sqf
    Función que detecta objetos eléctricos (lamparas, postes, techos de gasolinera, etc.)
    dentro de un radio fijo y los destruye para simular un apagón.
*/

params [
    // Lista de posiciones en formato [[x,y,z],[x,y,z],...]
    ["_positions", [], [[]]]
];

// ==== Recorremos cada posición de la lista ====
{
    private _pos = _x;                // Toma la posición actual de la iteración

    // Busca todos los objetos cercanos en un radio de 600m (sin filtrar tipo)
    {
        private _type = typeOf _x;    // Obtiene la clase del objeto actual

        // Si el objeto es una lámpara o uno de los postes/estructuras especificadas
        if (
            (_type find "Lamp") > -1                          // Contiene "Lamp" en su nombre
            || _type isEqualTo "Land_PowerPoleWooden_L_F"     // Poste eléctrico grande
            || _type isEqualTo "Land_PowerPoleWooden_F"       // Poste eléctrico mediano
            || _type isEqualTo "Land_PowerPoleWooden_small_F" // Poste eléctrico pequeño
            || _type isEqualTo "Land_FuelStation_01_roof_malevil_F" // Techo de gasolinera con luces
        ) then {
            _x setDamage 1;           // Destruye el objeto simulando apagón
        };
    } forEach (nearestObjects [_pos, [], 600]);  // Objetos en 600m alrededor de _pos

} forEach _positions;       // Recorre todas las posiciones
