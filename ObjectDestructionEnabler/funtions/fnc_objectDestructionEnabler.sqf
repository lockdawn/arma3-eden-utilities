/*
    Función: fnc_ObjectDestructionEnablerScript
    Autor: Roberto

    Descripción:
        Habilita un evento de destrucción personalizada para un objeto.
        El objeto se elimina automáticamente cuando su daño supera 0.25.

    Parámetros:
        0: OBJECT - Objeto al que se le agregará el EH HandleDamage.

    Ejemplo:
        [myObject] call fnc_ObjectDestructionEnablerScript;

*/

params ["_obj", "_dmg"];

if (isNil "_obj" || {isNull _obj}) exitWith {
    diag_log "[fnc_ObjectDestructionEnablerScript] ERROR: Objeto _obj inválido.";
};

if (isNil "_dmg" || {isNull _dmg}) exitWith {
    diag_log "[fnc_ObjectDestructionEnablerScript] ERROR: Objeto _dmg inválido.";
};

_obj addEventHandler ["HandleDamage", {

    params ["_target","_selection","_damage","_source","_projectile"];

    if (damage _target > _dmg) then {
        DESTROYED_OBJECT = true;
        deleteVehicle _target;
    };

    _damage   // ← IMPORTANTE: debes devolver el daño final
}];
