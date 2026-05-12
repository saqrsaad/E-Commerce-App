```markdown
# 🛍️ Flutter E-Commerce App (API + Offline)

A full-featured multi‑screen shopping app built with **Flutter**, **Provider**, and **real API data**.  
It demonstrates clean architecture, state management, offline caching, and advanced error handling.

---

# ✨ Features

- **Live API Data** – Products, categories, and cart fetched from [FakeStore API](https://fakestoreapi.com)
- **Offline Support** – First successful load caches products locally; app works without internet using cached data
- **Category Filter** – Horizontal category chips (loaded from API)
- **Favorites** – Heart icon toggles favorites, persisted with `SharedPreferences`
- **Shopping Cart** – Add/remove items, quantity controls, subtotal/tax/total calculation (local state with silent API sync)
- **Error Handling** – Try/catch, timeout (10s), status‑code translation to Arabic user‑friendly messages
- **Loading & Empty States** – CircularProgressIndicator while fetching, retry button on error, empty cart/favorites messages
- **Product Detail Screen** – Tap a product to see full description and image
- **Cart Badge** – Real‑time item count on cart icon
- **Performance Optimized** – `Consumer`, `Selector`, `listen: false`, `const` constructors
- **Custom Theme** – Gradient app bar, Poppins font, clean colours

---

# 📁 Project Structure

```plaintext
ecommerce_app/
├── lib/
│   ├── main.dart                          # App entry, MultiProvider, bottom navigation
│   ├── models/
│   │   ├── product.dart                   # Product model + JSON serialization
│   │   ├── cart_item_model.dart           # Cart item for local logic
│   │   └── cart_model.dart                # Cart & CartItemApi for API responses
│   ├── services/
│   │   ├── base_api_service.dart          # Generic HTTP service, timeout, error handling
│   │   ├── product_service.dart           # fetchProducts(), fetchCategories()
│   │   ├── cart_service.dart              # fetchCart(), addToCart(), removeFromCart()
│   │   └── api_exception.dart             # Custom exception with status code & message
│   ├── helpers/
│   │   └── local_storage.dart             # Cache/restore products using SharedPreferences
│   ├── providers/
│   │   ├── product_provider.dart          # Product list, category filtering, loading states
│   │   ├── favorites_provider.dart        # Favorites set, persisted locally
│   │   └── cart_provider.dart             # Cart management, calculations, sync attempts
│   ├── screens/
│   │   ├── home_screen.dart               # Product grid with loading/error states
│   │   ├── favorites_screen.dart          # List of favourite products
│   │   ├── cart_screen.dart               # Cart with quantity controls & summary
│   │   └── product_detail_screen.dart     # (Bonus) Full product details
│   ├── widgets/
│   │   ├── product_card.dart              # Product card (image, name, price, heart, add to cart)
│   │   ├── cart_item_tile.dart            # Cart item row with +/– and delete
│   │   └── error_widget.dart              # Reusable error display with retry button
│   └── theme/
│       └── app_theme.dart                 # Gradient, font and colour definitions
├── pubspec.yaml
└── README.md
```

---

# 📝 Commentary on Key Files

## `base_api_service.dart`
Centralized HTTP client. Adds default headers (`Content-Type`, `Accept`), enforces a 10‑second timeout, and translates common network / status errors into Arabic messages (`ApiException`).

## `product_service.dart`
Inherits `BaseApiService` and fetches product list from `GET /products` and categories from `GET /products/categories`. Data is parsed using `Product.fromJson`.

## `product_provider.dart`
Manages loading state (`idle` → `loading` → `success` / `error`). On failure, falls back to cached products via `LocalStorage`, enabling offline browsing.

## `local_storage.dart`
Stores the last successful product list as JSON in `SharedPreferences`. On next launch, if internet is unavailable, the cached data is displayed instantly.

## `favorites_provider.dart`
Favourites are kept locally as a `Set<Product>` and serialised to `SharedPreferences` after each change, so they persist across app restarts.

## `cart_screen.dart`
Uses `Selector<CartProvider, double>` to rebuild only the total section when the total changes, keeping the UI snappy.

---

# 🚀 Getting Started

## Prerequisites

- Flutter SDK ≥ 3.0
- Android Studio / VS Code
- A device/emulator or Chrome for web

## Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/saqrsaad/E-Commerce-App.git
   cd ecommerce-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run -d chrome          # Web
   flutter run -d <device_id>     # Mobile/Desktop
   ```

> **Note:** Internet permission is already enabled in `AndroidManifest.xml` and `macOS` entitlements.

---

# 📸 Screenshots

<p align="center">
  <img src="screenshots/1.png" width="200"/>  <!-- Home with loading -->
  <img src="screenshots/2.png" width="200"/>  <!-- Product grid -->
  <img src="screenshots/3.png" width="200"/>  <!-- Favourites empty -->
  <img src="screenshots/4.png" width="200"/>  <!-- Favourites filled -->
  <img src="screenshots/5.png" width="200"/>  <!-- Cart with items -->
  <img src="screenshots/6.png" width="200"/>  <!-- Product detail -->
  <img src="screenshots/7.png" width="200"/>  <!-- Error state -->
  <img src="screenshots/8.png" width="200"/>  <!-- Offline mode -->
</p>

---

# 🌐 Web Deployment

## Netlify
```bash
flutter build web
```
Then:
- Log in to [Netlify](https://netlify.com)
- Drag & drop the `build/web` folder
- Your site will deploy instantly

## Firebase Hosting
```bash
npm install -g firebase-tools
firebase login
firebase init hosting
# Set public directory to build/web
firebase deploy --only hosting
```

---

# 🧪 Testing

| Scenario | Expected Result |
|----------|-----------------|
| **Airplane mode** | App loads cached products & shows “لا يوجد اتصال” if no cache |
| **Reduce timeout to 2s** | Error message “انتهت مهلة الاتصال” |
| **Request invalid product ID** | “البيانات غير موجودة” (404) |
| **Add to cart** | Item appears, badge updates, silent API sync |
| **Remove from cart** | Item disappears immediately |

---

# 🧰 Built With

- [Flutter](https://flutter.dev)
- [Provider](https://pub.dev/packages/provider)
- [http](https://pub.dev/packages/http)
- [shared_preferences](https://pub.dev/packages/shared_preferences)
- [google_fonts](https://pub.dev/packages/google_fonts)
- [FakeStore API](https://fakestoreapi.com)

---

# 📄 License

This project is open-source and available under the MIT License.
```