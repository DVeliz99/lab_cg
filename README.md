# 🧪 LAB_CG - App de Salud Móvil

**LAB_CG** es una aplicación móvil desarrollada con el objetivo de brindar comodidad, seguridad y eficiencia a los pacientes al momento de gestionar sus servicios de salud. Con una interfaz moderna y funcional, permite agendar citas, visualizar resultados clínicos y llevar un control personalizado desde el celular.

---

## 📲 Funcionalidades Principales

- **Inicio de sesión seguro**  
  Acceso mediante usuario y contraseña para pacientes registrados.

- **Agendar citas médicas a domicilio**  
  Selección de tipo de examen, fecha, hora y dirección para toma de muestras en casa.

- **Catálogo de servicios clínicos**  
  Visualización de estudios disponibles con precios y agendamiento rápido.

- **Pantalla de inicio personalizada**  
  Muestra la próxima cita programada y accesos directos a funcionalidades clave.

- **Historial de resultados clínicos**  
  Acceso a resultados por fecha, con opción para descargar en PDF.

- **Visualización detallada de resultados**  
  Valores como hemoglobina, glóbulos rojos, plaquetas, entre otros.

- **Gestión de perfil**  
  Edición de información personal como nombre, edad, sexo, tipo de sangre, altura, peso, teléfono, correo y dirección.

- **Configuración del sistema**  
  Administración del método de contacto preferido, notificaciones e información general sobre la app.

---

## 🏗️ Estructura del Proyecto

La aplicación sigue una **arquitectura limpia (Clean Architecture)**, separando responsabilidades en diferentes capas para facilitar el mantenimiento y escalabilidad del código.

lib/
├── core/ # Configuraciones generales y utilidades del sistema
├── data/
│ ├── data_sources/ # Conexión con las fuentes de datos (Firebase, APIs, local)
│ ├── firebase_data_sources/ # Implementaciones específicas para Firebase
│ ├── implements/ # Implementaciones concretas de repositorios
│ └── repositories/ # Interfaces de repositorios
├── domain/ # Entidades centrales como usuario, cita, resultados, etc.
├── presentation/
│ ├── screens/ # Pantallas de la aplicación
│ └── widgets/ # Componentes reutilizables de UI
└── use_cases/ # Casos de uso que definen la lógica del negocio

## 🛠️ Tecnologías Utilizadas

- **Flutter** (framework principal)
- **Firebase Authentication** (gestión de usuarios)
- **Cloud Firestore** (base de datos en tiempo real)
- **Firebase Storage** (almacenamiento de PDFs de resultados)
- **Dart** (lenguaje de programación)

---

## 🚀 Instalación y Build

### Requisitos:

- Flutter SDK instalado
- Android Studio o Visual Studio Code
- Emulador Android o dispositivo físico

### Clonar el repositorio:

### Clonar el repositorio:

git clone https://github.com/DVeliz99/lab_cg.git
cd lab_cg

- Instalar dependencias:

flutter pub get

- Correr en modo desarrollo:

flutter run
Generar APK:

flutter build apk --release
El APK generado se encuentra en:
build/app/outputs/flutter-apk/app-release.apk
