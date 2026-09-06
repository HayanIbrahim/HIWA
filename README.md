# 🌦️ HiWeather (HIWA) - Production-Grade Flutter Weather App

[![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-blueviolet)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
[![State Management](https://img.shields.io/badge/State%20Management-BLoC%208.1+-blue)](https://bloclibrary.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Tests](https://img.shields.io/badge/Tests-16%2F16%20Passing-brightgreen)]()
[![Analysis](https://img.shields.io/badge/Static%20Analysis-0%20Warnings-brightgreen)]()

> A modern, offline-first weather intelligence application built with **Flutter**, adhering to strict **Clean Architecture** principles, **BLoC** pattern, declarative routing with **GoRouter**, and live interactive radar mapping.

---

## 📌 Overview

**HiWeather** is an enterprise-grade mobile application designed to showcase advanced Flutter engineering practices. Powered by the **OpenWeatherMap One Call 3.0 API**, the app delivers hyper-local weather tracking, dynamic atmospheric canvas animations that respond to live conditions, interactive meteorological radar layers, and an offline-first experience with sub-second cache retrieval.

The project highlights strict **Separation of Concerns**, functional error handling, dependency injection, declarative navigation, and complete bilingual localization (**English LTR & Arabic RTL**).

---

## ✨ Key Features

### ⛅ Comprehensive Weather Intelligence
- **Hero Condition & Metrics**: Real-time temperature, condition badge, "feels like" metric, and high/low ranges.
- **Next-Hour Precipitation Rate**: Minutely bar graph charting the next 60 minutes of rainfall intensity.
- **48-Hour Hourly Timeline**: Smooth horizontal scroll highlighting hourly weather icons and precipitation probability percentages (`%`).
- **8-Day Outlook with Normalized Temp Bars**: Visual min/max temperature gradient bars calculated relative to the weekly temperature extremes.
- **Deep Metrics Grid**: Real-time UV Index with risk rating, Wind Speed & Compass Direction, Humidity & Dew Point, Barometric Pressure, and Visibility.
- **Severe Weather Alert System**: Expandable emergency banner warning users of official meteorological advisories.

### 🗺️ Interactive Weather Radar Map (`flutter_map`)
- Integrated with OpenWeather Map Tile Layer API overlays over CartoDB base maps.
- Real-time layer switching between:
  - 🌧️ **Precipitation** (`precipitation_new`)
  - 🌡️ **Temperature** (`temp_new`)
  - 💨 **Wind Speed** (`wind_new`)
  - ☁️ **Cloud Coverage** (`clouds_new`)
- Dynamic opacity control, interactive pinch-to-zoom, and city geolocation pin markers.

### 🌐 Bilingual Localization (English & Arabic RTL)
- Native support for **English (LTR)** and **Arabic (RTL)** configured via `.arb` files and compiled `AppLocalizations`.
- Centralized typography system automatically switching between **Google Fonts Cairo** for Arabic and **Outfit** for English.
- Symmetrical layout flipping ensuring all icons, drawers, cards, and forecast timelines render naturally in RTL.

### 📱 Offline-First Architecture
- High-performance local caching using **Hive NoSQL** storage.
- Instant display of previously fetched weather upon app launch without network blocking.
- Subtle `OfflineBadge` informing the user when cached data is being displayed alongside relative update timestamps (`"5m ago"` / `"منذ 5 دقائق"`).
- Graceful resilience mode with built-in mock fixtures ensuring zero UI crashes even during server outages or rate-limiting.

### 🎨 Design System & Visual Polish
- **Dynamic Atmospheric Animations**: Custom canvas particle painter generating continuous condition-based effects (falling raindrops, snowflakes, glowing sun rays, drifting clouds, and twinkling night stars).
- **Glassmorphism UI**: Custom frosted-glass containers using `BackdropFilter` with customized blur and subtle surface borders.
- **Skeleton Shimmer Loaders**: Shimmer placeholder states during data retrieval.
- **Full Theme Support**: System Default, Light Mode, and Dark Mode.

---

## 🏛️ Clean Architecture & Design Patterns

The codebase strictly isolates business logic from frameworks, UI, and external data sources:

```
                      ┌─────────────────────────────────┐
                      │        Presentation Layer       │
                      │  (Pages, Widgets, BLoC States)  │
                      └────────────────┬────────────────┘
                                       │ depends on
                                       ▼
                      ┌─────────────────────────────────┐
                      │          Domain Layer           │
                      │  (Entities, Use Cases, Repos)   │
                      │       * Pure Dart Only *        │
                      └────────────────▲────────────────┘
                                       │ implements
                                       │
                      ┌────────────────┴────────────────┐
                      │           Data Layer            │
                      │ (DTOs, Data Sources, Hive Cache)│
                      └────────────────┬────────────────┘
                                       │ uses
                                       ▼
                      ┌─────────────────────────────────┐
                      │           Core Layer            │
                      │(Network, Theme, Router, DI, Err)│
                      └─────────────────────────────────┘
```

### 1. Domain Layer (`lib/domain/`)
- **Entities**: Pure immutable business models (`WeatherEntity`, `HourlyForecastEntity`, `DailyForecastEntity`, `WeatherAlertEntity`, `MinutelyPrecipitationEntity`, `LocationEntity`).
- **Repositories (Contracts)**: Abstract interfaces defining data access without leaking third-party SDKs (`IWeatherRepository`, `ILocationRepository`).
- **Use Cases**: Single-responsibility interactors (`GetFullWeatherUseCase`, `GetCurrentLocationUseCase`, `SearchLocationsUseCase`, etc.).

### 2. Data Layer (`lib/data/`)
- **DTOs**: Data Transfer Objects with `fromJson`, `toJson`, and explicit `.toDomain()` mapper methods.
- **Remote Data Source**: Dio client consuming OpenWeather One Call 3.0 API with interceptors.
- **Local Data Source**: Hive-backed persistence for offline caching.
- **Repository Implementations**: Coordinates the network-first strategy, cache writing, and offline fallback.

### 3. Presentation Layer (`lib/presentation/`)
- **BLoC Pattern**: State management powered by `flutter_bloc` with distinct Event and State models inheriting from `Equatable`.
- **Feature Grouping**: Code organized by feature domain (`weather`, `radar_map`, `locations`, `settings`).
- **Atomic Components**: Highly reusable, tested UI components.

### 4. Core Layer (`lib/core/`)
- Centralized network configurations, dependency injection container (`GetIt`), declarative routing (`GoRouter`), theme tokens, and custom `Failure`/`Exception` handling.

---

## 🛠️ Tech Stack & Dependencies

| Category | Package | Justification |
|---|---|---|
| **State Management** | `flutter_bloc` + `equatable` | Predictable, event-driven state transitions with value-equality checks. |
| **Routing** | `go_router` | Declarative, deep-linkable navigation with `StatefulShellRoute` tab preservation. |
| **Networking** | `dio` | Robust HTTP client featuring timeout management, request/response interceptors, and error handling. |
| **Dependency Injection**| `get_it` + `injectable` | Decoupled service locator for fast, mockable dependency resolution. |
| **Mapping** | `flutter_map` + `latlong2` | High-performance raster tile layer rendering supporting OpenWeather overlays. |
| **Local Storage** | `hive` + `hive_flutter` | Lightweight, blazingly fast NoSQL key-value store for offline caching. |
| **Geolocation** | `geolocator` + `geocoding` | Cross-platform GPS coordinate fetching and reverse geocoding. |
| **Internationalization**| `flutter_localizations` + `intl` | Official Flutter l10n with `.arb` compilation for English & Arabic. |
| **UI & Typography** | `google_fonts` + `shimmer` | Typography engine (Cairo / Outfit) and skeleton loading states. |
| **Testing** | `bloc_test` + `mocktail` | High-fidelity BLoC state transition testing and dependency mocking. |

---

## 📂 Project Structure

```text
lib/
├── core/
│   ├── constants/             # API endpoints, tile layer keys, cache config
│   ├── di/                    # Dependency injection (GetIt) setup
│   ├── error/                 # Failure & Exception classes
│   ├── network/               # DioClient, ApiInterceptor, ErrorInterceptor
│   ├── router/                # AppRouter with GoRouter & StatefulShellRoute
│   ├── services/              # LocationService (GPS & geocoding)
│   ├── theme/                 # AppColors, AppTypography, AppTheme, WeatherThemeExtension
│   └── utils/                 # UnitConverter, AppDateFormatter, WeatherMapper
├── domain/
│   ├── entities/              # WeatherEntity, Forecasts, Alerts, Locations
│   ├── repositories/          # IWeatherRepository, ILocationRepository
│   └── usecases/              # Weather & Location business use cases
├── data/
│   ├── datasources/           # WeatherRemoteDataSource, WeatherLocalDataSource, LocationDataSource
│   ├── fixtures/              # WeatherMockData fixture for resilient offline development
│   ├── models/                # DTOs with JSON serialization & toDomain()
│   └── repositories/          # WeatherRepositoryImpl, LocationRepositoryImpl
├── presentation/
│   ├── common_widgets/        # GlassCard, ShimmerLoader, OfflineBadge, ErrorView
│   ├── features/
│   │   ├── weather/           # WeatherBloc, WeatherHomePage, atmospheric background, forecast strips
│   │   ├── radar_map/         # MapBloc, WeatherMapPage with flutter_map & tile overlays
│   │   ├── locations/         # LocationBloc, ManageLocationsPage with search & bookmarks
│   │   └── settings/          # SettingsBloc, SettingsPage (Theme, Language, Units)
│   └── shell/                 # AppShell with NavigationBar
├── l10n/
│   ├── app_en.arb             # English localization bundle
│   ├── app_ar.arb             # Arabic localization bundle
│   └── generated/             # Auto-generated AppLocalizations
└── main.dart                  # Application entry point with Hive & DI initialization
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>= 3.13.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.13.0`)
- An OpenWeatherMap API Key ([Get one here](https://home.openweathermap.org/api_keys))

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/HayanIbrahim/HIWA.git
   cd HIWA
   ```

2. **Configure Environment Variables:**
   Copy `.env.example` to `.env` and insert your OpenWeatherMap API Key:
   ```bash
   cp .env.example .env
   ```
   Edit `.env`:
   ```env
   OPENWEATHER_API_KEY=your_openweather_api_key_here
   BASE_URL=https://api.openweathermap.org
   ```

3. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

4. **Generate Localizations:**
   ```bash
   flutter gen-l10n
   ```

5. **Run the Application:**
   ```bash
   flutter run
   ```

---

## 🧪 Testing & Verification

The codebase includes comprehensive unit, widget, and BLoC tests:

```bash
flutter test
```

### Test Suite Summary
- ✅ `SettingsBloc Tests`: Verifies ThemeMode, Arabic/English locale, and metric/imperial unit state transitions.
- ✅ `MapBloc Tests`: Verifies active tile layer switching and map coordinate navigation.
- ✅ `UnitConverter Tests`: Verifies Celsius/Fahrenheit, metric/imperial speed, pressure, and humidity calculations.
- ✅ `WeatherMapper Tests`: Verifies condition code mapping to animations, colors, and iconography.
- ✅ `WeatherMockData Tests`: Verifies data integrity across 48-hour hourly and 8-day daily structures.
- ✅ `CurrentWeatherCard`: Validates hero weather rendering and layout bindings.
- ✅ `GlassCard`: Validates backdrop blur container rendering.

### Static Code Analysis
Run the analyzer to confirm zero linter errors:
```bash
flutter analyze
```

---

## 👤 Author

**Hayan Ibrahim**
- GitHub: [@HayanIbrahim](https://github.com/HayanIbrahim)
- Repository: [https://github.com/HayanIbrahim/HIWA](https://github.com/HayanIbrahim/HIWA)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
