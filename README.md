# 📁 TuProyecto

Este repositorio contiene la estructura modular del proyecto, organizado por capas para mantener una separación clara de responsabilidades.

---

## 📂 Estructura del proyecto

📁 LAB_CG/
│
├── 📁 data/
│ ├── 📁 data_sources/ # Fuentes de datos (API, Firebase, Base de datos local)
│ ├── 📁 firebase_data_source/ # Implementación específica de Firebase como fuente de datos
│ ├── 📁 repositories/ # Interfaces de repositorios
│ ├── 📁 implements_repository/ # Implementaciones concretas de los repositorios
│
├── 📁 Core/
│ ├── 📁 firebase/ # Configuración de Firebase (autenticación, base de datos, almacenamiento)
│ ├── 📁 machine_learning/ # Modelos de Machine Learning y procesamiento de datos
│ ├── 📁 utils/ # Funciones auxiliares y configuraciones comunes
│ ├── 📁 errors/ # Manejo de errores global
│
├── 📁 domain/ # Contiene las entidades y lógica central de negocio
│
├── 📁 use_cases/ # Lógica de negocio y operaciones principales
│
├── 📁 presentation/
│ ├── 📁 screens/ # Pantallas de la aplicación
│ ├── 📁 widgets/ # Componentes reutilizables

---

## ✅ Buenas prácticas

- Mantener las **dependencias unidireccionales**:
  `presentation → use_cases → domain`
- Usar **interfaces** para invertir dependencias en `data/repositories`.
- Realizar **tests unitarios** sobre entidades y casos de uso.
- Reutilizar widgets y evitar lógica de negocio en la capa de UI.

---

## 👥 Equipo

- **Coordinador**: Dario Veliz
- **Equipo**: Mabel Pineda, Fernando Mendez, Leonel Sandoval

---

> 💬 Para cualquier duda sobre la estructura del proyecto, por favor contacta al coordinador.
