# The Editorial Estate

> Premium Real Estate Discovery — A digital curator for modern living.

**The Editorial Estate** is a high-end Flutter application designed for property discovery. It combines a sophisticated "Digital Curator" aesthetic with powerful map-based search capabilities, providing a premium experience for users looking for their next home.

## ✨ Key Features

- **🗺️ Interactive Map Exploration**: Seamlessly discover properties via a high-performance map interface with custom markers and clusters.
- **💎 Premium Property Details**: Immersive views for every estate, featuring high-resolution galleries, detailed specifications, and location insights.
- **🚀 Dynamic Onboarding**: A smooth, visually driven introduction to the app's core value propositions.
- **❤️ Saved Estates**: Track your favorite properties with a dedicated wishlist system.
- **👤 Personalized Profile**: A sleek dashboard for user preferences and saved data.
- **📱 Responsive Navigation**: A sophisticated shell structure for fluid transitions between core features.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev) (Dart)
- **Architecture**: **Clean Architecture** (Separation of concerns into Domain, Data, and Presentation layers)
- **State Management**: [BLoC](https://pub.dev/packages/flutter_bloc) (Business Logic Component)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **Dependency Injection**: [GetIt](https://pub.dev/packages/get_it)
- **Map Visualization**: [flutter_map](https://pub.dev/packages/flutter_map) & [latlong2](https://pub.dev/packages/latlong2)
- **Typography & Icons**: [Google Fonts](https://pub.dev/packages/google_fonts) (Outfit & Inter)
- **Testing**: Bloc Test, Mocktail, and Flutter Test

## 📂 Project Structure

```text
lib/
├── core/                # Shared utilities, themes, and base components
└── features/
    ├── onboarding/      # App introduction flow
    ├── explore/         # Map-based property search
    ├── property_detail/ # Detailed estate information
    ├── saved/           # Wishlist functionality
    ├── profile/         # User dashboard
    └── shell/           # Core navigation and layout
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- CocoaPods (for iOS)
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**:
   ```bash
   git clone <repository_url>
   cd editorial_estate
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

---

*Part of the Geodwelling Map series — Built with precision and style.*
