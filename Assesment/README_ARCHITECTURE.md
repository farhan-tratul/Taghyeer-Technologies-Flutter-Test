# Taghyeer - Flutter E-Commerce Application

A production-quality Flutter application built with Clean Architecture, BLoC state management, and DummyJSON API integration.

## Features

✅ **Authentication**
- Login with DummyJSON API
- Session persistence
- Auto-login on app startup
- Logout functionality

✅ **Products Tab**
- Display products with pagination
- Product listing with thumbnails
- Price and rating display
- Load more on scroll

✅ **Posts Tab**
- Display posts with pagination
- Post preview with body summary
- Tags display
- Load more on scroll

✅ **Settings Tab**
- User profile information display
- Theme switcher (Light/Dark mode)
- Theme persistence
- Logout option

✅ **Advanced Features**
- Clean Architecture implementation
- BLoC state management
- API error handling
- Network error handling
- Local caching with SharedPreferences
- Theme persistence
- Pagination support
- Dependency injection with GetIt

## Architecture

```
lib/
├── core/                 # Core layer
│   ├── constants/       # API and storage constants
│   ├── network/         # HTTP client wrapper
│   ├── theme/           # Theme configuration
│   └── utils/           # Exceptions and utilities
├── data/                # Data layer
│   ├── datasources/     # Remote and local data sources
│   ├── models/          # Data transfer objects
│   └── repositories/    # Repository implementations
├── domain/              # Business logic layer
│   ├── entities/        # Business entities
│   ├── repositories/    # Repository abstractions
│   └── usecases/        # Use case implementations
└── presentation/        # Presentation layer
    ├── bloc/            # BLoC state management
    ├── screens/         # Application screens
    └── widgets/         # Reusable widgets
```

## Project Structure Details

### Core Layer
- **network/api_client.dart**: HTTP client wrapper with error handling
- **theme/app_theme.dart**: Light and dark theme definitions
- **utils/exceptions.dart**: Custom exception classes
- **constants/api_constants.dart**: API endpoints and constants

### Data Layer
- **datasources/**: Remote (API calls) and local (SharedPreferences) data sources
- **models/**: DTOs with JSON serialization (using json_annotation)
- **repositories/**: Implementation of domain repositories

### Domain Layer
- **entities/**: Pure Dart classes representing business logic
- **repositories/**: Abstract interfaces for data operations
- **usecases/**: Business logic use cases (Login, GetProducts, GetPosts, etc.)

### Presentation Layer
- **bloc/**: State management for Auth, Products, Posts, and Theme
- **screens/**: Login, Home (with bottom nav), Products, Posts, Settings
- **widgets/**: Reusable components (LoadingWidget, ErrorWidget, EmptyStateWidget)


This project is proprietary and confidential.

---

**Built with ❤️ using Flutter**
