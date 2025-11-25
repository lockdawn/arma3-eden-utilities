# 📘 Sistema de Intel

Esta función convierte cualquier objeto del editor en un **objeto de inteligencia (Intel)** totalmente funcional para Arma 3.  
Al recogerlo, el jugador obtiene automáticamente una entrada dentro de *Diario → Intel*, con imagen, título y contenido narrativo.

---

## 📂 Ubicación

```
functions/fnc_miscript.sqf
```

---

## 🧩 Uso

```sqf
[_obj, _img, _title, _msg] call fnc_miscript;
```

### Parámetros

| Parámetro | Tipo   | Descripción |
|----------|--------|-------------|
| `_obj`   | Object | Objeto que contendrá el Intel |
| `_img`   | String | Ruta de la imagen a mostrar |
| `_title` | String | Título del registro de Intel |
| `_msg`   | String | Contenido HTML del informe |

---

## 📝 Qué hace la función

1. Asigna una imagen personalizada al Intel.  
2. Crea una entrada de diario con título y texto.  
3. Define qué bando puede leer el Intel (BLUFOR por defecto).  
4. Propaga la información al servidor y a todos los clientes (multiplayer seguro).

---

## 📘 Ejemplo desde un *trigger*

```sqf
private _obj   = intel_obj_1;
private _img   = "images\un_hostage.paa";
private _title = "Informe del Sgto. Makele";

private _msg = "<br/>General de División Usain Sinjen:<br/><br/> ... etc ...";

[_obj, _img, _title, _msg] call fnc_miscript;
```

---

## 📘 Ejemplo desde el init de un objeto

```sqf
private _msg = "<br/>General de División Usain Sinjen:<br/><br/> ... etc ...";

[this, "images\un_hostage.paa", "Informe del Sgto. Makele", _msg] call fnc_miscript;
```

---

## ✔️ Ventajas

- Añade narrativa y contexto a misiones de forma elegante.  
- Compatible con multiplayer y JIP.  
- Fácil de integrar a cualquier misión.

## ⚠️ Consideraciones

- Requiere que la misión incluya la estructura estándar de funciones (`CfgFunctions`).  
- Las rutas de imágenes deben existir dentro del escenario o mod.  
