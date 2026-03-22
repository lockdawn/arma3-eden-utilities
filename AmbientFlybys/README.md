# ✈️ Ambient Flyby's

Es una función diseñada para generar tráfico aéreo ambiental en tu misión de Arma 3. Permite crear sobrevuelos de aeronaves de forma automática, aleatoria y optimizada, sin necesidad de colocar unidades manualmente en el editor.

Su objetivo principal es **mejorar la inmersión** del escenario mediante actividad aérea constante sin afectar significativamente el rendimiento del servidor.

------------------------------------------------------------------------

## 📂 Estructura del Escenario

    mi_mision.Altis/
    │
	├── description.ext
	├── diary.sqf
    ├── initServer.sqf
	├── mission.sqm
    └── functions/
        └── fnc_ambientFlybys.sqf
	
------------------------------------------------------------------------

## 🧩 Instalación Paso a Paso

### 1. Ubicación del archivo

Coloca el archivo `fnc_ambientFlybys.sqf` en tu estructura de misión:

    functions/fnc_ambientFlybys.sqf

------------------------------------------------------------------------

### 2. Registrar la función en `description.ext`

Para poder usar `fnc_ambientFlybys.sqf` como una función dentro de la misión, es necesario registrarla en el archivo `description.ext`.

Este paso le indica a Arma 3 dónde se encuentra el archivo y bajo qué nombre podrá ser llamado posteriormente.

#### 🔍 Antes de agregar el código

Primero debes revisar si dentro de tu `description.ext` ya existe la clase:

```sqf
class CfgFunctions
```

Esto es importante porque muchas misiones ya utilizan **CfgFunctions** para registrar otras funciones personalizadas.

✅ **Si CfgFunctions ya existe**

En ese caso no debes volver a crearla.
Solo tienes que agregar dentro de tu estructura existente la categoría Ambient y la función ambientFlybys.

#### Ejemplo:

**Antes**
``` sqf
class CfgFunctions {
    class FEL {
        class Ejemplo {
            class miFuncion {
                file = "functions\fnc_miFuncion.sqf";
            };
        };
    };
};
```

**Después**
``` sqf
class CfgFunctions {
    class FEL {
        class Ejemplo {
            class miFuncion {
                file = "functions\fnc_miFuncion.sqf";
            };
        };
		class Ambient {
            class ambientFlybys {
                file = "functions\fnc_ambientFlybys.sqf";
            };
        };
    };
};
```

Esta sección debe colocarse dentro de tu tag principal, por ejemplo class FEL.

❌ **Si CfgFunctions no existe**

Entonces debes agregar la estructura completa en tu `description.ext`:

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

### 3. Ejecutar la función desde `initServer.sqf`

La función `fnc_ambientFlybys` está diseñada para ejecutarse automáticamente al inicio de la misión y únicamente del lado del servidor. Por esta razón, se utiliza el archivo `initServer.sqf`.

#### 📁 1. Crear el archivo

En la raíz de tu misión (misma carpeta donde está `description.ext`), crea un archivo llamado:

    initServer.sqf

#### 📝 2. Agregar la llamada a la función

Dentro de ese archivo, coloca:

    [] spawn FEL_fnc_ambientFlybys;

#### 📌 ¿Qué es `initServer.sqf`?

Es un archivo de sistema de Arma 3 que:

-   Se ejecuta automáticamente al iniciar la misión
-   Solo se ejecuta en el servidor (dedicado o host)
-   Se ejecuta una sola vez

Esto lo convierte en el lugar ideal para iniciar sistemas globales como este.

------------------------------------------------------------------------

## ⚙️ Guía de Configuración

### 📍 Requisito obligatorio

Debes crear un marker en el mapa con el siguiente nombre de variable:

    BIS_mapCenter

Se recomienda utilizar un marcador **invisible** para este propósito.

En el editor Eden:

1. Presiona **F6 (Markers)**
2. Ve a la categoría **System**
3. Selecciona el marcador llamado **Empty**

Este tipo de marcador:

-   ✔️ Es completamente invisible durante la misión  
-   ✔️ No interfiere con otros marcadores visibles del mapa  
-   ✔️ Es ideal para lógica interna de scripts  

La posición del marker es **muy importante**, ya que desde ahí se calculan todas las rutas de vuelo.

Tienes dos opciones recomendadas:

-   🟢 **Opción 1 — Centro del mapa**: Colocar el marker en el centro del mapa garantiza una distribución uniforme de los sobrevuelos en todo el terreno.
-   🟡 **Opción 2 — Centro del área de operaciones (Recomendado)**: Colocar el marker en la zona donde realmente se desarrollará la misión (AO) es la mejor práctica.

Esto permite que:

-   Las aeronaves pasen más cerca de los jugadores  
-   El efecto visual sea más consistente  
-   Se evite actividad innecesaria en zonas irrelevantes del mapa  

⚠️ **Importante**

-   Si el marker está mal colocado, los sobrevuelos pueden ocurrir lejos de los jugadores  
-   Si el marker no existe, la función no funcionará

------------------------------------------------------------------------

### ✈️ Personalización de aeronaves

La función `fnc_ambientFlybys` permite personalizar completamente el tipo de aeronaves que aparecerán en tu misión. Esto se realiza modificando la lista (array) de configuración ubicado dentro del propio archivo.

### 📍 ¿Dónde editar?

Dentro del archivo `fnc_ambientFlybys.sqf` encontrarás una sección similar a esta:

```sqf
private _types = [
    [150, "FULL", "B_Plane_CAS_01_F"],
    [40, "NORMAL", "B_Heli_Light_01_F"],
    [60, "NORMAL", "B_Heli_Transport_01_F"],
    [80, "NORMAL", "O_Heli_Light_02_F"]
];
```
Cada línea representa una aeronave posible que el sistema puede generar.

### 🧠 Estructura de cada entrada

Cada aeronave se define con la siguiente estructura:

    [ALTURA, VELOCIDAD, CLASE]

| Parámetro | Descripción                                      | Tipo   | Ejemplo            |
|-----------|--------------------------------------------------|--------|--------------------|
| ALTURA    | Altura de vuelo en metros sobre el terreno (AGL) | Number | 150                |
| VELOCIDAD | Modo de velocidad ("NORMAL" o "FULL")            | String | "FULL"             |
| CLASE     | Classname del vehículo                           | String | "B_Plane_CAS_01_F" |

### 📏 Valores de ALTURA

La altura se mide en metros sobre el terreno (AGL).

Valores recomendados:

| Tipo de aeronave  | Altura recomendada |
|-------------------|--------------------|
| Helicóptero bajo  | 20 – 60            |
| Helicóptero medio | 60 – 120           |
| Avión (CAS)       | 100 – 200          |
| Avión (JET)       | 200 – 500+         |

### ⚠️ Consideraciones

-   Valores muy bajos (<20) pueden provocar colisiones con terreno u objetos
-   Valores muy altos (>500) pueden hacer que la aeronave sea difícil de ver

### 🧠 Valores de VELOCIDAD

Solo se permiten los siguientes valores:

    "NORMAL"
    "FULL"


| Valor  | Comportamiento                  |
|--------|---------------------------------|
| NORMAL | Velocidad estándar del vehículo |
| FULL   | Velocidad máxima                |


Recomendación:

-   Helicópteros → "NORMAL" (más realista)
-   Aviones → "FULL" (mejor efecto visual)

### 💡 Recomendaciones generales

-   Mantén una mezcla equilibrada entre helicópteros y aviones
-   Evita agregar demasiadas aeronaves pesadas (jets) si buscas rendimiento
-   Ajusta altura y velocidad según el tipo de aeronave para mayor realismo
-   Prueba diferentes configuraciones hasta encontrar el equilibrio visual deseado

------------------------------------------------------------------------

## ⚡ Ventajas y Performance

-   ✔️ No requiere unidades pre-colocadas en el editor
-   ✔️ Bajo impacto en CPU y servidor
-   ✔️ Las aeronaves se eliminan automáticamente
-   ✔️ No genera lógica compleja de IA
-   ✔️ Ideal para misiones grandes o persistentes

Comparado con spawns manuales o IA completa, este sistema es significativamente más ligero.

------------------------------------------------------------------------

## ⚠️ Limitaciones

Este sistema es puramente ambiental, por lo tanto:

-   ❌ No genera comportamiento táctico
-   ❌ Las aeronaves no atacan ni interactúan
-   ❌ No se pueden controlar fácilmente después del spawn
-   ❌ No es adecuado para CAS real o inserciones

## 🚫 Cuándo NO usarlo

-   Misiones donde las aeronaves deban combatir
-   Escenarios con lógica avanzada de IA aérea
-   Sistemas donde se requiera control directo sobre unidades

## 🎯 Resultado esperado

Al implementar esta función correctamente, obtendrás:

-   Tráfico aéreo dinámico
-   Mayor realismo e inmersión
-   Sistema automático y optimizado
