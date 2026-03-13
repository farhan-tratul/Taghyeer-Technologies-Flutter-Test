# File Reference Guide

## Quick Navigation

### Core Layer - Network & Utilities
| File | Purpose |
|------|---------|
| `lib/core/network/api_client.dart` | HTTP client wrapper handling all API requests and error responses |
| `lib/core/theme/app_theme.dart` | Light/dark theme definitions with colors and typography |
| `lib/core/utils/exceptions.dart` | Custom exception classes for error handling |
| `lib/core/constants/api_constants.dart` | API endpoints and storage keys |

### Data Layer - Models

**User Data:**
| File | Purpose |
|------|---------|
| `lib/data/models/user_model.dart` | User DTO with JSON serialization from API |

**Product Data:**
| File | Purpose |
|------|---------|
| `lib/data/models/product_model.dart` | Product DTO extending Product entity |

**Post Data:**
| File | Purpose |
|------|---------|
| `lib/data/models/post_model.dart` | Post DTO extending Post entity |

**Pagination:**
| File | Purpose |
|------|---------|
| `lib/data/models/pagination_response_model.dart` | Generic paginated response wrapper |

### Data Layer - Data Sources

**Authentication:**
| File | Purpose |
|------|---------|
| `lib/data/datasources/remote/auth_remote_datasource.dart` | Handles login API calls |
| `lib/data/datasources/local/auth_local_datasource.dart` | Manages user session in SharedPreferences |

**Products:**
| File | Purpose |
|------|---------|
| `lib/data/datasources/remote/products_remote_datasource.dart` | Fetches products from API with pagination |

**Posts:**
| File | Purpose |
|------|---------|
| `lib/data/datasources/remote/posts_remote_datasource.dart` | Fetches posts from API with pagination |

### Data Layer - Repositories

| File | Purpose |
|------|---------|
| `lib/data/repositories/auth_repository_impl.dart` | Coordinates auth between remote API and local cache |
| `lib/data/repositories/products_repository_impl.dart` | Handles product data fetching |
| `lib/data/repositories/posts_repository_impl.dart` | Handles post data fetching |

### Domain Layer - Entities

| File | Purpose |
|------|---------|
| `lib/domain/entities/user.dart` | Business entity for User |
| `lib/domain/entities/product.dart` | Business entity for Product |
| `lib/domain/entities/post.dart` | Business entity for Post |

### Domain Layer - Repository Interfaces

| File | Purpose |
|------|---------|
| `lib/domain/repositories/auth_repository.dart` | Abstract interface for authentication |
| `lib/domain/repositories/products_repository.dart` | Abstract interface for products with response wrapper |
| `lib/domain/repositories/posts_repository.dart` | Abstract interface for posts with response wrapper |

### Domain Layer - Use Cases

**Authentication:**
| File | Purpose |
|------|---------|
| `lib/domain/usecases/auth/auth_usecases.dart` | Contains: LoginUseCase, GetCachedUserUseCase, LogoutUseCase, HasValidSessionUseCase |

**Products:**
| File | Purpose |
|------|---------|
| `lib/domain/usecases/products/get_products_usecase.dart` | Fetches products with pagination support |

**Posts:**
| File | Purpose |
|------|---------|
| `lib/domain/usecases/posts/get_posts_usecase.dart` | Fetches posts with pagination support |

### Presentation Layer - BLoC (State Management)

**Authentication BLoC:**
| File | Purpose |
|------|---------|
| `lib/presentation/bloc/auth/auth_event.dart` | Events: LoginEvent, CheckSessionEvent, LogoutEvent, GetCachedUserEvent |
| `lib/presentation/bloc/auth/auth_state.dart` | States: AuthInitial, AuthLoading, AuthSuccess, AuthFailure, SessionValid/Invalid, LogoutSuccess |
| `lib/presentation/bloc/auth/auth_bloc.dart` | Processes auth events and manages auth flow |

**Products BLoC:**
| File | Purpose |
|------|---------|
| `lib/presentation/bloc/products/products_event.dart` | Events: FetchProductsEvent, LoadMoreProductsEvent |
| `lib/presentation/bloc/products/products_state.dart` | States: ProductsInitial, ProductsLoading, ProductsLoaded, ProductsPaginationLoading, ProductsError, ProductsEmpty |
| `lib/presentation/bloc/products/products_bloc.dart` | Manages products list and pagination |

**Posts BLoC:**
| File | Purpose |
|------|---------|
| `lib/presentation/bloc/posts/posts_event.dart` | Events: FetchPostsEvent, LoadMorePostsEvent |
| `lib/presentation/bloc/posts/posts_state.dart` | States: PostsInitial, PostsLoading, PostsLoaded, PostsPaginationLoading, PostsError, PostsEmpty |
| `lib/presentation/bloc/posts/posts_bloc.dart` | Manages posts list and pagination |

**Theme BLoC:**
| File | Purpose |
|------|---------|
| `lib/presentation/bloc/theme/theme_event.dart` | Events: ToggleThemeEvent, InitializeThemeEvent |
| `lib/presentation/bloc/theme/theme_state.dart` | States: LightThemeState, DarkThemeState |
| `lib/presentation/bloc/theme/theme_bloc.dart` | Manages theme switching and persistence |

### Presentation Layer - Screens

| File | Purpose |
|------|---------|
| `lib/presentation/screens/auth/login_screen.dart` | Login screen with username/password form |
| `lib/presentation/screens/home/home_screen.dart` | Home screen with bottom navigation (Products, Posts, Settings) |
| `lib/presentation/screens/products/products_screen.dart` | Products list with infinite scroll pagination |
| `lib/presentation/screens/posts/posts_screen.dart` | Posts list with infinite scroll pagination |
| `lib/presentation/screens/settings/settings_screen.dart` | User profile, theme toggle, logout |

### Presentation Layer - Common Widgets

| File | Purpose |
|------|---------|
| `lib/presentation/widgets/common/error_widget.dart` | Error state UI with retry button |
| `lib/presentation/widgets/common/loading_widget.dart` | Loading state UI with spinner |
| `lib/presentation/widgets/common/empty_state_widget.dart` | Empty state UI when no data |

### Entry Point

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point, dependency injection setup, BLoC providers, route configuration |

### Configuration Files

| File | Purpose |
|------|---------|
| `pubspec.yaml` | Project dependencies and metadata |

### Documentation Files (Root)

| File | Purpose |
|------|---------|
| `README_ARCHITECTURE.md` | Comprehensive architecture documentation |
| `SETUP_GUIDE.md` | Quick start guide and usage instructions |
| `CODE_SNIPPETS.md` | Detailed code examples and patterns |
| `PROJECT_SUMMARY.md` | Project overview and statistics |
| `FILE_REFERENCE.md` | This file - quick reference guide |

---

## Code Organization by Feature

### Authentication Feature
```
User Action (Login)
  ↓
LoginScreen (presentation/screens/auth/)
  ↓
AuthBloc (presentation/bloc/auth/)
  ↓
LoginUseCase (domain/usecases/auth/)
  ↓
AuthRepository (domain/repositories/ & data/repositories/)
  ↓
AuthRemoteDataSource (data/datasources/remote/)
  + AuthLocalDataSource (data/datasources/local/)
  ↓
UserModel (data/models/)
  ↓
User Entity (domain/entities/)
```

### Products Feature
```
Screen Load (products_screen.dart)
  ↓
ProductsBloc (presentation/bloc/products/)
  ↓
GetProductsUseCase (domain/usecases/products/)
  ↓
ProductsRepository (domain/repositories/ & data/repositories/)
  ↓
ProductsRemoteDataSource (data/datasources/remote/)
  ↓
ProductModel (data/models/)
  ↓
Product Entity (domain/entities/)
```

### Posts Feature
```
Screen Load (posts_screen.dart)
  ↓
PostsBloc (presentation/bloc/posts/)
  ↓
GetPostsUseCase (domain/usecases/posts/)
  ↓
PostsRepository (domain/repositories/ & data/repositories/)
  ↓
PostsRemoteDataSource (data/datasources/remote/)
  ↓
PostModel (data/models/)
  ↓
Post Entity (domain/entities/)
```

### Theme Feature
```
Settings Screen (settings_screen.dart)
  ↓
ThemeBloc (presentation/bloc/theme/)
  ↓
SharedPreferences (core/network/)
  ↓
AppTheme (core/theme/)
```

---

## File Statistics

### By Layer
- **Core Layer**: 4 files (utils, API, theme, constants)
- **Data Layer**: 13 files (4 models, 5 data sources, 3 repositories, 1 pagination)
- **Domain Layer**: 10 files (3 entities, 3 repositories, 4 use cases)
- **Presentation Layer**: 20 files (12 BLoCs, 5 screens, 3 widgets)
- **Entry Point**: 1 file (main.dart)

**Total: 48+ files** implementing a complete production-quality application

### By Type
- **BLoCs**: 12 files (events, states, logic)
- **Data Sources**: 5 files (remote, local)
- **Repositories**: 6 files (interfaces + implementations)
- **Screens**: 5 files (complete UI)
- **Entities**: 3 files (business models)
- **Models**: 4 files (DTOs)
- **Widgets**: 3 files (reusable UI)
- **Utilities**: 4 files (core, theme, exceptions, constants)
- **Entry**: 1 file (main.dart)

---

## Import Patterns

### Importing from Data Layer
```dart
import 'lib/data/models/user_model.dart';
import 'lib/data/datasources/remote/auth_remote_datasource.dart';
import 'lib/data/repositories/auth_repository_impl.dart';
```

### Importing from Domain Layer
```dart
import 'lib/domain/entities/user.dart';
import 'lib/domain/repositories/auth_repository.dart';
import 'lib/domain/usecases/auth/auth_usecases.dart';
```

### Importing from Presentation Layer
```dart
import 'lib/presentation/bloc/auth/auth_bloc.dart';
import 'lib/presentation/bloc/auth/auth_event.dart';
import 'lib/presentation/bloc/auth/auth_state.dart';
import 'lib/presentation/screens/auth/login_screen.dart';
import 'lib/presentation/widgets/common/error_widget.dart';
```

### Importing from Core Layer
```dart
import 'lib/core/network/api_client.dart';
import 'lib/core/theme/app_theme.dart';
import 'lib/core/utils/exceptions.dart';
import 'lib/core/constants/api_constants.dart';
```

---

## Common File Modifications

### To Add New Feature

1. **Entity file** - `lib/domain/entities/my_feature.dart`
2. **Model file** - `lib/data/models/my_feature_model.dart`
3. **Remote DS file** - `lib/data/datasources/remote/my_feature_remote_datasource.dart`
4. **Repository interface** - `lib/domain/repositories/my_feature_repository.dart`
5. **Repository impl** - `lib/data/repositories/my_feature_repository_impl.dart`
6. **Use case file** - `lib/domain/usecases/my_feature/get_my_features_usecase.dart`
7. **BLoC event file** - `lib/presentation/bloc/my_feature/my_feature_event.dart`
8. **BLoC state file** - `lib/presentation/bloc/my_feature/my_feature_state.dart`
9. **BLoC file** - `lib/presentation/bloc/my_feature/my_feature_bloc.dart`
10. **Screen file** - `lib/presentation/screens/my_feature/my_feature_screen.dart`
11. **Register in** - `lib/main.dart` (setupDependencies function)

### To Fix Imports
- Always check the file path in the structure above
- Use relative imports within layers: `import '../models/user_model.dart';`
- Use absolute imports across layers: `import 'lib/domain/entities/user.dart';`

---

## Quick File Search

**Looking for?**
| What | Where |
|------|-------|
| API endpoints | `lib/core/constants/api_constants.dart` |
| Theme configuration | `lib/core/theme/app_theme.dart` |
| Error handling | `lib/core/utils/exceptions.dart` |
| HTTP calls | `lib/core/network/api_client.dart` |
| User authentication | `lib/presentation/screens/auth/login_screen.dart` |
| Products list | `lib/presentation/screens/products/products_screen.dart` |
| Posts list | `lib/presentation/screens/posts/posts_screen.dart` |
| User profile | `lib/presentation/screens/settings/settings_screen.dart` |
| State management | `lib/presentation/bloc/*/` |
| Business logic | `lib/domain/usecases/*/` |
| Data models | `lib/data/models/` |
| API integration | `lib/data/datasources/remote/` |
| Persistence | `lib/data/datasources/local/auth_local_datasource.dart` |

---

## Next Steps for Development

1. **Run the project** - Follow SETUP_GUIDE.md
2. **Understand the flow** - Read CODE_SNIPPETS.md
3. **Learn the structure** - Review PROJECT_SUMMARY.md
4. **Add features** - Use file reference above as template
5. **Test the app** - Use provided test credentials

---

Generated for **Taghyeer Flutter Application** - Production Quality E-Commerce App
