/*
    fnc_miscript
    Quita la venda (goggles) de un rehén y elimina la acción para evitar repetición.
*/

params ["_target"];  
// Recibe el objeto (rehén) al que se le agregará la acción.

_target addAction [                        
    // Agrega una acción contextual al rehén.

    "Quitar Venda de los Ojos",            
    // Texto que verá el jugador en el menú de acción.

    {
        params ["_target","_caller","_actionId"];  
        // Recibe el rehén, el jugador que ejecutó la acción y el ID de la acción.

        removeGoggles _target;             
        // Quita la venda (goggles) del rehén.

        _target removeAction _actionId;    
        // Elimina la acción para que no pueda usarse más de una vez.
    }
];
