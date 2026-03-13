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

## Getting Started

### Prerequisites
- Flutter 3.6+
- Dart 3.0+

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd taghyeer
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate JSON serialization files** (if using json_serializable)
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Dependencies

### State Management
- **flutter_bloc**: ^8.1.4 - BLoC pattern implementation
- **bloc**: ^8.1.2 - Core BLoC library

### Networking
- **http**: ^1.1.0 - HTTP client

### Local Storage
- **shared_preferences**: ^2.2.2 - Local key-value storage

### Dependency Injection
- **get_it**: ^7.6.0 - Service locator
- **injectable**: ^2.2.2 - Dependency injection code generation

### Utilities
- **equatable**: ^2.0.5 - Value equality for Dart classes
- **json_annotation**: ^4.8.1 - JSON serialization annotations
- **json_serializable**: ^6.7.1 - JSON serialization code generation

## API Endpoints

### Authentication
```
POST https://dummyjson.com/auth/login
Headers: Content-Type: application/json
Body: {
  "username": "emilys",
  "password": "emilyspass",
  "expiresInMins": 30
}
```

### Products
```
GET https://dummyjson.com/products?limit=10&skip=0
```

### Posts
```
GET https://dummyjson.com/posts?limit=10&skip=0
```

## Test Credentials

Username: `emilys`
Password: `emilyspass`

## State Management Flow

### Authentication BLoC
- **Events**: LoginEvent, CheckSessionEvent, LogoutEvent, GetCachedUserEvent
- **States**: AuthInitial, AuthLoading, AuthSuccess, AuthFailure, SessionValid, SessionInvalid, LogoutSuccess

### Products BLoC
- **Events**: FetchProductsEvent, LoadMoreProductsEvent
- **States**: ProductsInitial, ProductsLoading, ProductsLoaded, ProductsPaginationLoading, ProductsError, ProductsEmpty

### Posts BLoC
- **Events**: FetchPostsEvent, LoadMorePostsEvent
- **States**: PostsInitial, PostsLoading, PostsLoaded, PostsPaginationLoading, PostsError, PostsEmpty

### Theme BLoC
- **Events**: ToggleThemeEvent, InitializeThemeEvent
- **States**: LightThemeState, DarkThemeState

## Error Handling

The application handles multiple error scenarios:
- **Network Errors**: No internet connection, connection timeouts
- **Server Errors**: HTTP 4xx and 5xx responses
- **Cache Errors**: Local storage failures
- **Deserialization Errors**: JSON parsing failures

Each screen displays user-friendly error messages with a retry button.

## Pagination Implementation

Products and Posts use infinite scrolling pagination:
1. Initial load: 10 items with `skip=0`
2. On scroll near bottom: Load next 10 items with `skip=10`, `skip=20`, etc.
3. `hasMoreData` flag tracks if more items exist

## Local Storage

Using SharedPreferences for:
- **User Session**: Complete user data (ID, username, email, token, etc.)
- **Theme Mode**: Boolean flag for dark/light mode preference

## Theme Switching

Theme preference is persisted locally:
1. User toggles dark mode switch in Settings
2. Theme change is applied immediately
3. Preference is saved to SharedPreferences
4. Theme is restored on app restart

## Development Best Practices Implemented

✅ Clean Architecture separation of concerns
✅ SOLID principles adherence
✅ Dependency injection for testability
✅ BLoC for predictable state management
✅ Error handling at multiple layers
✅ Consistent code formatting
✅ Type-safe API communication
✅ Local data persistence
✅ Pagination for performance
✅ UI/UX best practices

## Future Enhancements

- [ ] Product detail screen
- [ ] Post detail screen with comments
- [ ] Search functionality
- [ ] Favorites/wishlist feature
- [ ] Cart functionality
- [ ] User profile editing
- [ ] Offline support with local cache
- [ ] Image caching
- [ ] Unit and widget tests
- [ ] Integration tests

## Troubleshooting

### JSON Serialization Issues
If you see `Missing generated file` errors:
```bash
flutter pub run build_runner clean
flutter pub run build_runner build
```

### Dependencies Not Installing
```bash
flutter clean
flutter pub get
```

### Hot Reload Not Working
Use hot restart or full app rebuild:
```bash
flutter run --no-fast-start
```

## License

This project is proprietary and confidential.

---

**Built with ❤️ using Flutter**
