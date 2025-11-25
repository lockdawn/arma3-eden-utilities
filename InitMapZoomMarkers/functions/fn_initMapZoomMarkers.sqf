/*
  Marcadores por zoom (cliente) — 2 grupos: FAR y NEAR
  - Usa EH "MouseZChanged" del mapa (display 12)
  - Debug: systemChat "[Markers] Banda: NEAR/FAR"
*/

if (!hasInterface) exitWith {};

// ===== Configura tus marcadores aquí =====
private _marksFar  = ["fob_mkr"];     // <-- NOMBRES EXACTOS (Name) "LEJOS"
private _marksNear = [
	"mrk_near_gn",
	"mrk_near_fa",
	"mrk_near_marina",
	"mrk_near_1",
	"mrk_near_2",
	"mrk_near_3",
	"mrk_near_4",
	"mrk_near_5",
	"mrk_near_6",
	"mrk_near_7",
	"mrk_near_8",
	"mrk_near_9",
	"mrk_near_10",
	"mrk_near_11",
	"mrk_near_12",
	"mrk_near_13",
	"mrk_near_14",
	"mrk_near_15",
	"mrk_near_16"
];   // <-- NOMBRES EXACTOS (Name) "CERCA"
private _THRESH    = 0.05;  // < 0.05 => NEAR ; >= 0.05 => FAR
// =========================================

// Guarda en uiNamespace para que el EH los vea
uiNamespace setVariable ["FEL_marksFar",  _marksFar];
uiNamespace setVariable ["FEL_marksNear", _marksNear];
uiNamespace setVariable ["FEL_thresh",    _THRESH];
uiNamespace setVariable ["FEL_band",      ""];       // banda actual cacheada
uiNamespace setVariable ["FEL_mapEH",     -1];       // id del EH activo (si existe)

// Función que aplica la banda (guardada en uiNamespace)
uiNamespace setVariable ["FEL_applyBand", {
  params ["_band"];
  private _far  = uiNamespace getVariable ["FEL_marksFar",  []];
  private _near = uiNamespace getVariable ["FEL_marksNear", []];

  // Mensaje de depuración
  //systemChat format ["[Markers] Banda: %1", _band];

  if (_band isEqualTo "NEAR") then {
    { _x setMarkerAlphaLocal 1 } forEach _near;
    { _x setMarkerAlphaLocal 0 } forEach _far;
  } else {
    { _x setMarkerAlphaLocal 0 } forEach _near;
    { _x setMarkerAlphaLocal 1 } forEach _far;
  };
}];

// EH principal: se activa al abrir/cerrar el mapa
addMissionEventHandler ["Map", {
  params ["_open", "_forced"];

  disableSerialization;

  if (_open) then {
    // Añade EH de rueda SOLO mientras el mapa está abierto
    private _disp = findDisplay 12;
    if (isNull _disp) exitWith {};

    // Estado inicial según el zoom actual
    private _mapCtrl = _disp displayCtrl 51;
    if (!isNull _mapCtrl) then {
      private _zoom = ctrlMapScale _mapCtrl;
      private _thr  = uiNamespace getVariable ["FEL_thresh", 0.05];
      private _band0 = if (_zoom < _thr) then {"NEAR"} else {"FAR"};
      uiNamespace setVariable ["FEL_band", _band0];
      ["NEAR","FAR"] select (_band0 == "FAR") params ["_dummy"]; // no hace nada, solo evita warnings
      [_band0] call (uiNamespace getVariable "FEL_applyBand");
    };

    // Crea el EH de zoom si no existe
    private _ehId = _disp displayAddEventHandler ["MouseZChanged", {
      disableSerialization;
      private _d = findDisplay 12;
      if (isNull _d) exitWith {};
      private _m = _d displayCtrl 51;
      if (isNull _m) exitWith {};

      private _zoom = ctrlMapScale _m;
      private _thr  = uiNamespace getVariable ["FEL_thresh", 0.05];
      private _bandNow = if (_zoom < _thr) then {"NEAR"} else {"FAR"};

      private _bandPrev = uiNamespace getVariable ["FEL_band",""];
      if !(_bandNow isEqualTo _bandPrev) then {
        uiNamespace setVariable ["FEL_band", _bandNow];
        [_bandNow] call (uiNamespace getVariable "FEL_applyBand");
      };
    }];

    uiNamespace setVariable ["FEL_mapEH", _ehId];

  } else {
    // Al cerrar el mapa, elimina el EH y (opcional) deja FAR
    private _disp = findDisplay 12;
    private _ehId = uiNamespace getVariable ["FEL_mapEH", -1];
    if (!isNull _disp && {_ehId >= 0}) then {
      _disp displayRemoveEventHandler ["MouseZChanged", _ehId];
    };
    uiNamespace setVariable ["FEL_mapEH", -1];

    // Deja FAR por defecto (opcional, quita si no lo quieres)
    uiNamespace setVariable ["FEL_band", "FAR"];
    ["FAR"] call (uiNamespace getVariable "FEL_applyBand");
  };
}];