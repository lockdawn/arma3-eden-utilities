# ✈️ Ambient Flyby's - fnc_ambientFlybys.sqf

## 📌 ¿Qué es y para qué sirve?

`fnc_ambientFlybys` es una función diseñada para generar tráfico aéreo ambiental dentro de tu misión de Arma 3. Su propósito es crear sobrevuelos de aeronaves de forma automática, aleatoria y ligera, sin necesidad de colocar unidades manualmente en el editor.

Esto permite que el escenario se sienta vivo, dinámico y con actividad constante, mejorando significativamente la inmersión del jugador sin añadir complejidad innecesaria.

---

## 🧩 Instalación Paso a Paso

### 1️⃣ Ubicación del archivo

```
functions/fnc_ambientFlybys.sqf
```

---

### 2️⃣ description.ext

```sqf
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

---

## 🧠 Guía de Configuración

### Marker requerido

```
BIS_mapCenter
```

### Trigger

```sqf
[] spawn FEL_fnc_ambientFlybys;
```

---

## ✈️ Configuración

```
[ALTURA, VELOCIDAD, CLASE]
```

### ALTURA

Metros AGL

| Tipo | Altura |
|------|--------|
| Heli bajo | 20–60 |
| Heli medio | 60–120 |
| CAS | 100–200 |
| Alto | 200–500+ |

### VELOCIDAD

```
"NORMAL"
"FULL"
```

---

## ⚡ Ventajas

- Bajo impacto
- Automático
- Sin IA pesada

---

## ⚠️ Limitaciones

- No combate
- No interacción

---

## 🎯 Resultado

- Inmersión
- Tráfico dinámico
