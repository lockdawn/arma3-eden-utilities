# ✈️ Ambient Flyby's

`fnc_ambientFlybys` es una función diseñada para generar tráfico aéreo
ambiental en tu misión de Arma 3.
Permite crear sobrevuelos de aeronaves de forma automática, aleatoria y
optimizada, sin necesidad de colocar unidades manualmente en el editor.

Su objetivo principal es **mejorar la inmersión** del escenario mediante
actividad aérea constante sin afectar significativamente el rendimiento
del servidor.

------------------------------------------------------------------------

## 🧩 Instalación Paso a Paso

### 1 Ubicación del archivo

Coloca el archivo en tu estructura de misión:

    functions/fnc_ambientFlybys.sqf

------------------------------------------------------------------------

### 2 Registrar la función en `description.ext`

Ejemplo de configuración:

``` sqf
class CfgFunctions {
    class FEL {
        class Ambient {
            class ambientFlybys {
                file = "functions\fnc_ambientFlybys.sqf";
            };
        };
    };
};
```

------------------------------------------------------------------------

## ⚙️ Guía de Configuración

### 📍 Requisito obligatorio

Debes crear un marker en el mapa con el siguiente nombre:

    BIS_mapCenter

Este marker define el punto central desde donde se calculan las rutas de
vuelo.

------------------------------------------------------------------------

### 🎯 Ejecutar desde un Trigger

#### Configuración recomendada:

-   **Tipo:** None
-   **Activación:** None
-   **Repetible:** No

#### Código en "On Activation":

``` sqf
[] spawn FEL_fnc_ambientFlybys;
```

Esto iniciará el sistema de sobrevuelos de forma continua en segundo
plano.

------------------------------------------------------------------------

## ⚡ Ventajas y Performance

-   ✔️ No requiere unidades pre-colocadas en el editor
-   ✔️ Bajo impacto en CPU y servidor
-   ✔️ Las aeronaves se eliminan automáticamente
-   ✔️ No genera lógica compleja de IA
-   ✔️ Ideal para misiones grandes o persistentes

Comparado con spawns manuales o IA completa, este sistema es
significativamente más ligero.

------------------------------------------------------------------------

## ⚠️ Limitaciones

Este sistema es puramente ambiental, por lo tanto:

-   ❌ No genera comportamiento táctico
-   ❌ Las aeronaves no atacan ni interactúan
-   ❌ No se pueden controlar fácilmente después del spawn
-   ❌ No es adecuado para CAS real o inserciones

------------------------------------------------------------------------

## 🚫 Cuándo NO usarlo

-   Misiones donde las aeronaves deban combatir
-   Escenarios con lógica avanzada de IA aérea
-   Sistemas donde se requiera control directo sobre unidades

------------------------------------------------------------------------

## 🎯 Resultado esperado

Al implementar esta función correctamente, obtendrás:

-   Tráfico aéreo dinámico
-   Mayor realismo e inmersión
-   Sistema automático y optimizado
