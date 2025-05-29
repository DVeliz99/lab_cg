## 📁 Descripción de carpetas

### `domain/`

Contiene las **entidades del dominio**. Son clases puras que representan objetos del negocio, como usuarios, órdenes, etc.

- 💡 No dependen de ninguna tecnología externa.
- 🗂 Ejemplos: `user.dart`, `order.dart`

---

### `use_cases/`

Contiene los **casos de uso** de la aplicación: lógica de negocio enfocada en una única acción o flujo.

- 💡 Se conectan con los repositorios definidos en `domain`.
- 🗂 Ejemplos: `create_user.dart`, `get_orders.dart`, `classify_image.dart`

---

### `data/`

Contiene todo lo relacionado con el **manejo de datos**, dividido en:

#### `repositories/`

Define las **interfaces de acceso a datos** (contratos) que serán implementadas por las fuentes concretas.

- 💡 Los casos de uso dependen de estas interfaces.
- 🗂 Ejemplos: `user_repository.dart`, `ml_repository.dart`

#### `data_sources/`

Implementaciones concretas que conectan con servicios como Firebase o modelos de ML.

- 💡 Aquí vive la integración con tecnologías externas.
- 🗂 Ejemplos: `firebase_user_data_source.dart`, `tensorflow_lite_data_source.dart`

---

### `presentation/`

Contiene todo lo relacionado con la **interfaz de usuario**.

#### `screens/`

Pantallas completas que representan vistas dentro de la aplicación.

- 🗂 Ejemplos: `user_screen.dart`, `image_classification_screen.dart`

#### `widgets/`

Componentes visuales reutilizables que se usan dentro de las pantallas.

- 🗂 Ejemplos: `user_card.dart`, `image_preview.dart`

---

### `core/`

Servicios y lógica transversal de uso general en toda la app.

- 💡 Incluye configuraciones comunes, manejo de errores y utilidades.
- 🗂 Ejemplos: `firebase_service.dart`, `ml_service.dart`, `failure.dart`

---

## ✅ Buenas prácticas

- Mantener las **dependencias unidireccionales**: `presentation → use_cases → domain`.
- Usar **interfaces** para invertir dependencias en `data/repositories`.
- Hacer **tests unitarios** sobre entidades y casos de uso.
- Reutilizar widgets y evitar lógica de negocio en la UI.

---

## 👥 Equipo

- Coordinador: Dario Veliz
- Equipo: Mabel Pineda, Fernando Mendez, Leonel Sandoval

---

> Cualquier duda sobre la estructura, comunícate con el coordinador del proyecto.
