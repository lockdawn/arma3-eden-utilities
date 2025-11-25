/*
    File: functions\fnc_miscript.sqf
    Descripción:
      Configura un objeto como fuente de Intel (entrada de diario)
      con imagen, título y texto personalizados para el bando BLUFOR.

    Uso:
      [_obj, _img, _title, _msg] call fnc_miscript;
*/

params [
    // 0: Objeto que será el contenedor del Intel (por ejemplo, una carpeta, foto, etc.)
    ["_obj", objNull, [objNull]],
    // 1: Ruta de la imagen que se mostrará en la entrada de diario
    ["_img", "", [""]],
    // 2: Título de la entrada de diario
    ["_title", "", [""]],
    // 3: Mensaje / contenido HTML de la entrada de diario
    ["_msg", "", [""]]
];

// Si no se recibió un objeto válido, salir para evitar errores
if (isNull _obj) exitWith {};

// --- CONFIGURACIÓN DEL INTEL EN EL OBJETO ---

// Guarda la textura (imagen) que usará la entrada de diario de este objeto
_obj setVariable [
    "RscAttributeDiaryRecord_texture", // nombre del atributo usado por el sistema de Intel
    _img,                              // ruta de la imagen pasada como parámetro
    true                               // true = se propaga a todos los clientes (publicVariable)
];

// Configura el registro de diario (título y mensaje) en el objeto
[
    _obj,                              // objeto que almacena el registro de diario
    "RscAttributeDiaryRecord",         // nombre del atributo (tipo de registro de diario)
    [_title, _msg]                     // array con [título, texto] del Intel
] call BIS_fnc_setServerVariable;      // función de BI para setear la variable en el servidor

// Define qué bando recibe este Intel (quién lo puede leer)
_obj setVariable [
    "recipients",                      // atributo que indica los receptores del Intel
    west,                              // BLUFOR (lado oeste)
    true                               // se sincroniza a todos los clientes
];

// Define quién “posee” el Intel (propietarios)
_obj setVariable [
    "RscAttributeOwners",              // atributo de propietarios del Intel
    [west],                            // array de lados propietarios (en este caso solo BLUFOR)
    true                               // se sincroniza a todos los clientes
];