 SeedBank Mobile App

> **Status:** 🚧 Under Active Development (قيد التطوير المستمر)

The official customer mobile application for the **SeedBank** ecosystem, built with **Flutter** using Clean Architecture, Riverpod, and Dartz for functional error handling. It allows users to browse agricultural products, manage shopping carts, maintain multiple delivery addresses, and sync favorites in real-time.

---

## 🌟 Key Features
* **Authentication:** Secure user authentication via Firebase Auth.
* **Server-Side Pagination:** Optimized product catalog browsing with Firestore cursors.
* **Shopping Cart & Real-time Favorites:** Seamless product synchronization and management.
* **Multiple Addresses Management:** Support for managing shipping addresses with region validation.
* **Functional Error Handling:** Strict implementation of `Either` (Dartz) across data layers.
* **State Management:** Fully reactive UI managed by **Flutter Riverpod** with granular states.

---

## 🏗️ Architecture & Standards
* **Architecture:** Feature-First & Clean Architecture (`data`, `domain`, `presentation`).
* **UI/UX & Components:** Reusable components from `core/widgets` (CustomTable, CustomTextFormField, CustomSnackBar).
* **Routing:** Declarative routing using **GoRouter**.

