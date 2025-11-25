# fnc_miscript — Acción de quitar venda para rehenes en Arma 3

## 📝 Descripción general
Esta función agrega al rehén una acción contextual llamada **“Quitar Venda de los Ojos”**, permitiendo que el jugador interactúe con la IA para retirarle la venda.  
Una vez ejecutada, la acción se elimina automáticamente y el rehén queda marcado como liberado visualmente, pudiendo ser detectado por un **trigger** u otro sistema de misión.

---

## 📂 Ubicación del archivo
```
functions/fnc_miscript.sqf
```

---

## ⚙️ Funcionamiento
- La función recibe el objeto del rehén como parámetro.
- Añade una acción al menú contextual del jugador.
- Al ejecutarse:
  - Quita las *goggles* del rehén (simulando quitar la venda).
  - Elimina la acción para evitar que pueda usarse más de una vez.
- Facilita la integración con triggers para detectar el rescate.

---

## 🚀 Uso en la misión
Para usar esta función en cualquier rehén, agrega en su campo **Init** (o en un script):

```sqf
[this] call fnc_miscript;
```

---

## 📌 Ejemplo de trigger de detección
Puedes detectar el rescate con un trigger usando esta condición:

```sqf
!(goggles rehénUnidad isEqualTo "G_Goggles_VR") // ejemplo si usabas goggles específicos
```

O más comúnmente:

```sqf
(goggles rehénUnidad isEqualTo [])
```

---

## 📈 Consideraciones de performance
- Es **ligero**, corre solo cuando el jugador interactúa.
- No usa bucles ni procesos persistentes.
- Totalmente seguro en entornos multiplayer (la acción se ejecuta local al cliente).

---

## ✔️ Pros de incorporar esta función
- Fácil de integrar en cualquier misión.
- Muy útil para operaciones de **rescate de rehenes**.
- Inmersivo: el jugador “retira” la venda manualmente.
- Compatible con triggers, sistemas de tareas, módulos Zeus y scripts personalizados.

---

## ❗ Contras
- Requiere que el rehén tenga goggles o “venda”.
- No notifica automáticamente al sistema de tareas (debe añadirse aparte si es necesario).