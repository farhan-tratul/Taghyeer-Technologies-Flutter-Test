# Quick Setup & Usage Guide

## Step 1: Get Dependencies

```bash
cd e:\Projects\Taghyeer
flutter pub get
```

## Step 2: Generate JSON Serialization (Optional but Recommended)

The app uses JSON serialization annotations. If you want to regenerate the serialization files:

```bash
flutter pub run build_runner build
```

This generates:
- `user_model.g.dart`
- `product_model.g.dart`
- `post_model.g.dart`
- `pagination_response_model.g.dart`

## Step 3: Run the Application

```bash
flutter run
```

For release build:
```bash
flutter run --release
```

## Step 4: Test the Application

### Login Screen
- Default credentials are pre-filled
- Username: `emilys`
- Password: `emilyspass`
- Click "Login" button

### Home Screen (After Login)
Bottom navigation has 3 tabs:

1. **Products Tab**
   - Displays products with pagination
   - Scroll down to load more products
   - Each product shows thumbnail, title, price, and rating

2. **Posts Tab**
   - Displays posts with pagination
   - Shows post title, body preview, and tags
   - Scroll down to load more posts

3. **Settings Tab**
   - Shows logged-in user information (name, username, email)
   - Toggle dark/light mode
   - Click logout button to sign out

## Dependency Injection Setup (main.dart)

The `setupDependencies()` function initializes:
1. SharedPreferences for local storage
2. HTTP client for API calls
3. API client wrapper
4. All data sources (Remote & Local)
5. All repositories
6. All use cases
7. All BLoCs

This is called in `main()` before running the app.

## Key Implementation Details

### Authentication Flow
```
LoginScreen 
  → AuthBloc.LoginEvent 
  → LoginUseCase 
  → AuthRepository 
  → AuthRemoteDataSource (API) + AuthLocalDataSource (Cache)
  → HomeScreen
```

### Session Management
```
App Startup 
  → AuthBloc.CheckSessionEvent
  → HasValidSessionUseCase
  → AuthLocalDataSource (Check cache)
  → SessionValid/SessionInvalid
```

### Products/Posts Flow
```
Screen Load 
  → BLoC.FetchEvent 
  → UseCase 
  → Repository 
  → RemoteDataSource (API)
  → Parse & display
  → Scroll bottom 
  → LoadMoreEvent
  → Append more items
```

### Theme Management
```
Settings Screen 
  → Toggle Switch 
  → ThemeBloc.ToggleThemeEvent
  → Save to SharedPreferences
  → Update MaterialApp theme
  → Restored on app restart
```

## File Organization

### Models & Entities

**Entities** (Domain layer - business logic):
- `User`, `Product`, `Post` in `domain/entities/`

**Models** (Data layer - DTOs):
- `UserModel`, `ProductModel`, `PostModel` in `data/models/`
- Models extend entities and add JSON serialization

### API Communication

All API calls go through:
1. `ApiClient` - HTTP wrapper with error handling
2. Remote data sources - API-specific logic
3. Repositories - Business logic for API calls

### State Management

Each feature has:
- `*Event` - User actions/requests
- `*State` - UI states (Loading, Success, Error, etc.)
- `*Bloc` - Event processing & state emission

## Common Tasks

### Adding New API Feature

1. **Create Entity** in `domain/entities/`
2. **Create Model** in `data/models/` (extends Entity)
3. **Create Remote DataSource** in `data/datasources/remote/`
4. **Create Repository** in `domain/repositories/` (abstract) and `data/repositories/` (impl)
5. **Create UseCase** in `domain/usecases/`
6. **Create BLoC** in `presentation/bloc/`
7. **Create Screen** in `presentation/screens/`
8. **Register in GetIt** in `main.dart`

### Handling Errors

All layers throw `AppException` subclasses:
- `NetworkException` - Network/connectivity issues
- `ServerException` - Server-side errors (4xx, 5xx)
- `CacheException` - Local storage issues
- `UnauthorizedException` - 401 responses

Screens display user-friendly error messages with retry buttons.

### Adding Local Caching

Use `AuthLocalDataSource` as a template:
1. Inject `SharedPreferences`
2. Use `setString(key, jsonEncode(data))` to save
3. Use `getString(key)` to retrieve
4. Catch `CacheException` for errors

## Debugging Tips

1. **Check BLoC state changes** - Use Flutter DevTools
2. **Network requests** - Add logging in `ApiClient.get/post()`
3. **Local storage** - Check SharedPreferences with `flutter pub get shared_preferences`
4. **JSON serialization errors** - Run `flutter pub run build_runner build` again

## Performance Considerations

1. **Pagination** - Fetches 10 items at a time to reduce payload
2. **Image loading** - Network images cached by Flutter
3. **BLoC instances** - Using GetIt singleton pattern for efficiency
4. **State rebuilds** - Only affected widgets rebuild via BlocBuilder

## Production Checklist

- [ ] Remove test credentials from login screen
- [ ] Add proper error logging
- [ ] Implement request timeout handling
- [ ] Add analytics
- [ ] Implement app versioning
- [ ] Add API rate limiting
- [ ] Implement proper authentication token refresh
- [ ] Add offline support
- [ ] Implement proper cache invalidation
- [ ] Add push notifications
- [ ] Setup CI/CD pipeline
- [ ] Add unit tests
- [ ] Add integration tests
- [ ] Setup crash reporting

---

**Need Help?** Check the README_ARCHITECTURE.md for detailed architecture documentation.
