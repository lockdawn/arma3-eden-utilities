// ========= Cargar funciones personalizadas ==========
call compile preprocessFileLineNumbers "functions\fnc_spawnBombsInTrigger.sqf";
call compile preprocessFileLineNumbers "functions\fnc_deleteBombsInTrigger.sqf";

// ========= Confirmación en RPT ==========
diag_log "fnc_spawnBombsInTrigger CARGADA EN initServer";
diag_log "fnc_deleteBombsInTrigger CARGADA EN initServer";