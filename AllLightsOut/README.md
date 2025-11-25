# 📄 README — Función `fnc_miscript` (Simulación de Apagón Eléctrico Localizado)

## 📝 Descripción General

`fnc_miscript` es una función diseñada para simular un **apagón eléctrico localizado** en Arma 3.  
A partir de una lista de posiciones, busca objetos relacionados con iluminación o infraestructura eléctrica dentro de un radio definido y los **destruye**, generando un efecto visual de apagón tras un evento (ataque, sabotaje, sobrecarga, destrucción de transformador, etc.).

La función está pensada para activarse desde **triggers**, **scripts**, o **eventos** en la misión.

---

## ⚙️ Funcionamiento

1. Recibe una lista de posiciones en formato `[[x,y,z], [x,y,z], ...]`.
2. En cada posición, busca objetos cercanos a un radio de **600 metros**.
3. Identifica lámparas, postes eléctricos y estructuras específicas.
4. Aplica `setDamage 1` a esos objetos para simular destrucción eléctrica.
5. El resultado es un área completamente a oscuras.

---

## 📂 Ubicación del archivo

```
functions/
└── fnc_miscript.sqf
```

---

## 🧩 Uso

### Llamar la función desde un script o trigger:
```sqf
[
    [
        [1000,2000,0],
        [1500,2100,0]
    ]
] call fnc_miscript;
```

---

## 📌 Listado de objetos afectados

La función destruye:

- Cualquier objeto cuya clase contenga `"Lamp"`
- `Land_PowerPoleWooden_L_F`
- `Land_PowerPoleWooden_F`
- `Land_PowerPoleWooden_small_F`
- `Land_FuelStation_01_roof_malevil_F`

---

## 📈 Consideraciones de Performance

- El uso de `nearestObjects` en radios grandes puede impactar el rendimiento si se usa en demasiadas posiciones simultáneamente.
- Se recomienda no ejecutar esta función de manera repetitiva, sino solo al momento del evento (explosión, sabotaje, etc.).
- Es ideal para misiones donde el apagón ocurre como **evento único** y no como acción continua.

---

## ✔️ Pros

- Mejora la inmersión al simular apagones realistas.
- Fácil de integrar en triggers o sistemas de script.
- Compatible con cualquier mapa y objetos que contengan “Lamp”.

---

## ❌ Contras

- En zonas urbanas muy densas puede afectar temporalmente el rendimiento al buscar demasiados objetos.
- Si el mapa usa clases personalizadas de lámparas, deben agregarse manualmente al script.

---

## 🧱 Ejemplo de integración con trigger (On Activation)

```sqf
[
    [
        getPos centralElectrica,
        getPos transformadorNorte
    ]
] call fnc_miscript;
```