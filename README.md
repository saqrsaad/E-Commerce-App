
---

```markdown
# 🛍️ Flutter E-Commerce App

A multi-screen shopping application built with **Flutter** and **Provider** for state management.
It demonstrates clean separation of UI and business logic using `ChangeNotifier` providers with performance-optimized widget rebuilds.

---

# ✨ Features

- **Product Catalog** – Browse 8 hardcoded products across 5 categories (All, Electronics, Fashion, Sports, Perfumes)
- **Category Filter** – Horizontal chip list to filter products
- **Favorites** – Heart icon to toggle favorites with a dedicated favorites screen
- **Shopping Cart** – Add/remove items, quantity controls, automatic subtotal/tax/total calculation
- **Real-time Badge** – Cart icon shows total item count
- **Performance Optimized** – Extensive use of `Consumer`, `Selector`, `listen: false`, and `const` constructors
- **Simple Gradient Theme** – Clean UI with custom colors, gradient app bar, and Google Fonts

---

# 📁 Project Structure

```plaintext
ecommerce_app/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   ├── product.dart
│   │   └── cart_item.dart
│   ├── providers/
│   │   ├── product_provider.dart
│   │   ├── favorites_provider.dart
│   │   └── cart_provider.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── favorites_screen.dart
│   │   └── cart_screen.dart
│   ├── widgets/
│   │   ├── product_card.dart
│   │   └── cart_item_tile.dart
│   └── theme/
│       └── app_theme.dart
├── pubspec.yaml
└── README.md


# 📝Commentary on Key Files
---


## main.dart

Entry point of the app. Wraps the application with `MultiProvider` and manages bottom navigation using `IndexedStack`.

## product_provider.dart

Contains the hardcoded product list and category filtering logic.

## favorites_provider.dart

Uses `Set<Product>` internally for managing favorites.

## cart_provider.dart

Handles cart operations and dynamic calculations:

- subtotal
- tax
- total

## cart_screen.dart

Uses `Selector` to rebuild only necessary sections when totals change.

---

# 🚀 Getting Started

## Prerequisites

- Flutter SDK ≥ 3.0
- VS Code / Android Studio

## Installation

### 1) Clone the repository

```bash
git clone https://github.com/saqrsaad/E-Commerce-App.git
cd ecommerce-app
```


---

# 📸 Screenshots

<p align="center">
  <img src="screenshots/1.png" width="200"/>
    <img src="screenshots/2.png" width="200"/>
  <img src="screenshots/3.png" width="200"/>
    <img src="screenshots/4.png" width="200"/>
  <img src="screenshots/5.png" width="200"/>
  <img src="screenshots/6.png" width="200"/>
 
  </p>

---

### 2) Install dependencies

```bash
flutter pub get
```

### 3) Run the app

```bash
flutter run -d chrome
flutter run -d <device>
```

---


# 🧰 Built With

- Flutter
- Provider
- Google Fonts

---

# 📄 License

This project is open-source and available under the MIT License.

