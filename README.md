# iSucurgal 📍  
![Swift](https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-0D96F6?style=for-the-badge&logo=swift&logoColor=white)
![CoreLocation](https://img.shields.io/badge/CoreLocation-6B7280?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-En%20desarrollo-orange?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)

**iSucurgal** es una aplicación desarrollada en **SwiftUI + Combine + CoreLocation**,  
orientada a automatizar registros de **entrada y salida** en sucursales mediante  
*detección inteligente por geolocalización*.  

La app cuenta con filtros de precisión, anti-jumps, distancias reales,  
geofencing manual, validación de estado, logs en vivo y sincronización preparada  
para futuros endpoints del backend.  

---

## 🚀 Tecnologías utilizadas

- **Swift 5.9+**
- **SwiftUI**
- **Combine**
- **CoreLocation**
- **CoreData**
- **MapKit**
- **Background Tasks (ready)**
- **Xcode 16+**
- Compatible con **iOS 17+**

---

## ✨ Funcionalidades principales

- 📍 **Detección automática** de entrada/salida a sucursales
- 🎯 **Filtro de precisión** para descartar GPS impreciso
- 🚫 **Anti-jump**: evita falsos eventos por saltos de señal
- 🏷️ **Registro en tiempo real**, con logs detallados en consola
- 🔄 **Reprocesamiento post-salida** para detectar nueva entrada inmediata
- 🧠 **Persistencia del estado actual** (`currentSucursalID`)
- 📡 **Soporte para simulación de ubicaciones (Xcode GPX)**
- 🧱 **Arquitectura modular** con managers, view models y servicios
- 🗂️ **CoreData listo** para historial y auditoría
- 🛰️ **Geofences integrados** (didEnter/didExit) con lógica de protección
- 📦 **Preparado para futuras integraciones de API** (login, sync, sucursales dinámicas)

---

## 🧱 Arquitectura del proyecto

```
iSucurgal/
├── Managers/
│ ├── RegistroManager.swift ← lógica de entrada/salida
│ └── LocationManager.swift ← wrapper de CoreLocation
│
├── ViewModels/
│ ├── RegistroViewModel.swift ← comunicación con UI
│ └── SucursalesViewModel.swift ← listado + datos de sucursales
│
├── Models/
│ ├── Sucursal.swift
│ └── Registro.swift
│
├── Persistence/
│ └── DataController.swift ← CoreData stack
│
├── Views/
│ ├── RegistroScreen.swift
│ ├── SucursalesListView.swift
│ └── DebugLocationView.swift
│
├── Resources/
│ ├── sucursales.json
│ └── Assets.xcassets
└── iSucurgalApp.swift
```

---

## 🔍 Lógica principal: Registro por ubicación

El núcleo de la app vive en **RegistroManager**, que implementa:

### 📌 1. Filtro de precisión  
Ignora ubicaciones cuyo `horizontalAccuracy > 50m`.

### 📌 2. Anti-jump  
Evita saltos artificiales marcando como inválidos movimientos de:
- Si la app detecta un salto mayor a **800m en menos de 5s**, lo descarta.

### 📌 3. Detección por radio real  
Cada sucursal tiene coordenadas propias.  
La app calcula la distancia exacta y valida:

- Si está dentro del radio (50m default) → **ENTRADA**
- Si estaba dentro y sale del radio → **SALIDA**

### 📌 4. Estado persistente  
La app mantiene `currentSucursalID` para saber:

- si estás dentro
- de dónde saliste
- si corresponde registrar un evento nuevo
- si debe ignorar duplicados

### 📌 5. Post-salida inteligente  
Si salís de una sucursal y hay otra cercana en el área:  
- la app evalúa automáticamente si corresponde registrar una **nueva entrada**.


---

## 📸 Screenshots

| <img src="https://github.com/matias-spinelli/matias-spinelli/blob/main/assets/iSucurgal/Home.png" width="260"/> | <img src="https://github.com/matias-spinelli/matias-spinelli/blob/main/assets/iSucurgal/Registros.png" width="260"/> |
|:--:|:--:|
| Home | Registros |

| <img src="https://github.com/matias-spinelli/matias-spinelli/blob/main/assets/iSucurgal/Sucursales.png" width="260"/> | <img src="https://github.com/matias-spinelli/matias-spinelli/blob/main/assets/iSucurgal/Sucursales-All.png" width="260"/> |
|:--:|:--:|
| Sucursales | Todas las Sucursales |

---

## 🔧 Instalación y ejecución

```bash
# Clonar el repositorio
git clone https://github.com/matias-spinelli/isucurgal.git

# Entrar al directorio
cd isucurgal

# Abrir el proyecto en Xcode
xed .

# Ejecutar en simulador o dispositivo real
```

💡 **Tip**

Para probar ubicaciones en Xcode:

`Debug → Simulate Location → Custom GPX…`

---

## ☁️ Backend (próximamente)

Próxima etapa: integrar:

- 🔐 Login + Token  
- 🔄 Sincronización de registros  
- 📥 Descarga dinámica de sucursales  
- 📝 Auditoría  
- 📊 Dashboard interno  

---

## 🎨 Diseño y estilo

| Concepto | Estilo |
|----------|--------|
| 🟦 Identidad | Celeste / azul Galicia |
| 📍 Mapas | MapKit + pins personalizados |
| 🔵 Estados | Dentro / fuera de sucursal |
| 🧭 Logs | Consola extendida + etiquetas de ubicación |

---

## 🌟 Créditos

Proyecto creado por **Matías Spinelli**  ([@matias-spinelli](https://github.com/matias-spinelli))


---

## 📜 Licencia

MIT License © 2025

📍 *“La ubicación no es un lugar — es un contexto.”*
