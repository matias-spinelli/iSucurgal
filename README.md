# iSucurgal 📍  
![Swift](https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-0D96F6?style=for-the-badge&logo=swift&logoColor=white)
![CoreLocation](https://img.shields.io/badge/CoreLocation-6B7280?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-En%20desarrollo-orange?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)

**iSucurgal** es una aplicación desarrollada en **SwiftUI + Combine**,
que consume el módulo **LocationRegisterKit** para gestionar registros de entrada y salida en sucursales mediante geolocalización.

El objetivo de esta app es mostrar y administrar sucursales y registros a través de interfaces limpias y rápidas, delegando toda la lógica de ubicación al módulo independiente.

---

## 🚀 Tecnologías utilizadas

- **Swift 5.9+**
- **SwiftUI**
- **Combine**
- **CoreLocation**
- **CoreData**
- **MapKit**
- **Background Tasks**
- **Swift Package Manager**
- **Xcode 16+**
- Compatible con **iOS 17+**


---

## ✨ Funcionalidades principales

- 🌐 Integración transparente con **LocationRegisterKit** para toda la lógica de geolocalización y registro de entradas y salidas.

- 🏠 **Home**: pantalla principal desde donde se puede navegar a **Registros** y a **Sucursales**. Sirve como punto de partida y resumen de la app.

- 🗂️ **Sucursales**: muestra una lista de sucursales. Al tocar una sucursal se puede ver su detalle con su posición en el mapa. También es posible acceder a una vista con **Todas las Sucursales**, visualizadas en un mapa completo.

- 📄 **Registros**: listado de registros de entrada y salida generados por el módulo, con información clara sobre cada evento.

---

## 🧱 Arquitectura del proyecto

```
iSucurgal/
├── Views/
│ ├── RegistroScreen.swift
│ ├── SucursalesListView.swift
│ └── DebugLocationView.swift
│
├── Resources/
│ └── Assets.xcassets
└── iSucurgalApp.swift
```


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

El módulo LocationRegisterKit ya está incluido como dependencia SPM y no requiere configuración adicional para probar la app.

---

## 🌟 Créditos

Proyecto creado por **Matías Spinelli**  ([@matias-spinelli](https://github.com/matias-spinelli))
Aplicación desarrollada en **Swift** como práctica para aprender CoreData, CoreLocation y SwiftPackageManager.

---

## 📜 Licencia

MIT License © 2025

📍 *“La ubicación no es un lugar — es un contexto.”*
