# Code Snippets & Implementation Examples

## Architecture Layers Overview

### 1. Entity Layer (Domain) - Business Logic

```dart
// File: lib/domain/entities/user.dart
class User extends Equatable {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? image;
  final String token;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.image,
    required this.token,
  });

  @override
  List<Object?> get props => [id, username, email, token];
}
```

**Key Points:**
- Pure Dart classes
- Use `Equatable` for value equality
- No framework dependencies
- Represent business concepts

### 2. Model Layer (Data) - DTOs

```dart
// File: lib/data/models/user_model.dart
@JsonSerializable()
class UserModel extends User {
  @JsonKey(name: 'id')
  final int userId;
  
  @JsonKey(name: 'username')
  final String userUsername;

  const UserModel({
    required this.userId,
    required this.userUsername,
    // ... other fields
  }) : super(
    id: userId,
    username: userUsername,
    // ... pass to parent
  );

  // JSON serialization
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // Local storage conversion
  Map<String, dynamic> toStorageJson() => {
    'id': userId,
    'username': userUsername,
    // ...
  };

  factory UserModel.fromStorageJson(Map<String, dynamic> json) => UserModel(
    userId: json['id'] as int,
    userUsername: json['username'] as String,
    // ...
  );
}
```

**Key Points:**
- Extends domain entities
- Handles JSON serialization/deserialization
- Provides conversion methods for different formats
- Maps API field names to Dart fields using `@JsonKey`

### 3. Remote Data Source (Data Layer)

```dart
// File: lib/data/datasources/remote/auth_remote_datasource.dart
abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String username,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    final response = await apiClient.post(
      endpoint: ApiConstants.loginEndpoint,
      body: {
        'username': username,
        'password': password,
        'expiresInMins': 30,
      },
    );
    
    return UserModel.fromJson(response);
  }
}
```

**Key Points:**
- Handles API communication
- Uses ApiClient for HTTP requests
- Parses JSON responses into models
- Throws exceptions on errors

### 4. Local Data Source (Data Layer)

```dart
// File: lib/data/datasources/local/auth_local_datasource.dart
abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearUser();
  Future<bool> hasValidSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final jsonString = jsonEncode(user.toStorageJson());
      await sharedPreferences.setString(
        StorageConstants.userSessionKey,
        jsonString,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to save user');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final jsonString = sharedPreferences.getString(
        StorageConstants.userSessionKey,
      );
      
      if (jsonString == null) return null;
      
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserModel.fromStorageJson(json);
    } catch (e) {
      throw CacheException(message: 'Failed to get user');
    }
  }

  @override
  Future<bool> hasValidSession() async {
    try {
      final user = await getCachedUser();
      return user != null && user.token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
```

**Key Points:**
- Manages SharedPreferences
- Converts data to/from JSON strings
- Throws specific exceptions
- Provides validation methods

### 5. Repository (Data Layer)

```dart
// File: lib/data/repositories/auth_repository_impl.dart

// Domain repository interface:
abstract class AuthRepository {
  Future<User> login({
    required String username,
    required String password,
  });
  Future<User?> getCachedUser();
  Future<void> logout();
  Future<bool> hasValidSession();
}

// Implementation:
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> login({
    required String username,
    required String password,
  }) async {
    try {
      // 1. Call remote API
      final userModel = await remoteDataSource.login(
        username: username,
        password: password,
      );
      
      // 2. Save to local storage
      await localDataSource.saveUser(userModel);
      
      // 3. Return entity (not model)
      return userModel;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Login failed');
    }
  }

  @override
  Future<User?> getCachedUser() async {
    try {
      return await localDataSource.getCachedUser();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearUser();
  }

  @override
  Future<bool> hasValidSession() async {
    return await localDataSource.hasValidSession();
  }
}
```

**Key Points:**
- Coordinates between data sources
- Combines remote + local data
- Returns domain entities, not models
- Implements domain repository interface

### 6. Use Case (Domain Layer)

```dart
// File: lib/domain/usecases/auth/auth_usecases.dart

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  // Can be called as: await loginUseCase(
  //   username: 'user',
  //   password: 'pass',
  // )
  Future<User> call({
    required String username,
    required String password,
  }) {
    return repository.login(
      username: username,
      password: password,
    );
  }
}

class GetCachedUserUseCase {
  final AuthRepository repository;

  GetCachedUserUseCase(this.repository);

  Future<User?> call() => repository.getCachedUser();
}

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<void> call() => repository.logout();
}

class HasValidSessionUseCase {
  final AuthRepository repository;

  HasValidSessionUseCase(this.repository);

  Future<bool> call() => repository.hasValidSession();
}
```

**Key Points:**
- Single responsibility (one operation per class)
- Use `call()` method for cleaner syntax
- No framework dependencies
- Simple wrappers around repository methods

### 7. BLoC - Events (Presentation Layer)

```dart
// File: lib/presentation/bloc/auth/auth_event.dart

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  const LoginEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}

class CheckSessionEvent extends AuthEvent {
  const CheckSessionEvent();
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}
```

**Key Points:**
- Represent user actions
- Immutable with `const` constructors
- Use `Equatable` for value comparison
- Each action is a separate class

### 8. BLoC - States (Presentation Layer)

```dart
// File: lib/presentation/bloc/auth/auth_state.dart

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final User user;
  const AuthSuccess(this.user);
  
  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
  
  @override
  List<Object?> get props => [message];
}

class SessionValid extends AuthState {
  final User user;
  const SessionValid(this.user);
  
  @override
  List<Object?> get props => [user];
}

class SessionInvalid extends AuthState {
  const SessionInvalid();
}
```

**Key Points:**
- Represent UI states
- Use immutable classes
- Include data needed by UI
- Have clear, descriptive names

### 9. BLoC Implementation (Presentation Layer)

```dart
// File: lib/presentation/bloc/auth/auth_bloc.dart

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final GetCachedUserUseCase getCachedUserUseCase;
  final LogoutUseCase logoutUseCase;
  final HasValidSessionUseCase hasValidSessionUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.getCachedUserUseCase,
    required this.logoutUseCase,
    required this.hasValidSessionUseCase,
  }) : super(const AuthInitial()) {
    // Register event handlers
    on<LoginEvent>(_onLogin);
    on<CheckSessionEvent>(_onCheckSession);
    on<LogoutEvent>(_onLogout);
  }

  // Event handler for LoginEvent
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    
    try {
      // Call use case
      final user = await loginUseCase(
        username: event.username,
        password: event.password,
      );
      
      // Emit success state
      emit(AuthSuccess(user));
    } on AppException catch (e) {
      // Handle known exceptions
      emit(AuthFailure(e.message));
    } catch (e) {
      // Handle unexpected errors
      emit(const AuthFailure('Unexpected error occurred'));
    }
  }

  // Event handler for CheckSessionEvent
  Future<void> _onCheckSession(
    CheckSessionEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final hasSession = await hasValidSessionUseCase();
      
      if (hasSession) {
        final user = await getCachedUserUseCase();
        if (user != null) {
          emit(SessionValid(user));
        } else {
          emit(const SessionInvalid());
        }
      } else {
        emit(const SessionInvalid());
      }
    } catch (e) {
      emit(const SessionInvalid());
    }
  }

  // Event handler for LogoutEvent
  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await logoutUseCase();
      emit(const LogoutSuccess());
      emit(const AuthInitial());
    } on AppException catch (e) {
      emit(AuthFailure(e.message));
    }
  }
}
```

**Key Points:**
- Register event handlers in constructor
- Handle events asynchronously
- Emit loading state before async operation
- Emit success or failure state
- Catch and handle exceptions properly

### 10. Screen - Using BLoC (Presentation Layer)

```dart
// File: lib/presentation/screens/auth/login_screen.dart

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // Trigger LoginEvent
    context.read<AuthBloc>().add(
      LoginEvent(
        username: _usernameController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocListener<AuthBloc, AuthState>(
        // Listen to BLoC changes for navigation
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          // Rebuild UI based on state
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    enabled: state is! AuthLoading,
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    enabled: state is! AuthLoading,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  if (state is AuthLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: _handleLogin,
                      child: const Text('Login'),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
```

**Key Points:**
- Use `BlocListener` for side effects (navigation, snackbars)
- Use `BlocBuilder` for UI updates based on state
- Trigger events with `context.read<AuthBloc>().add(...)`
- Check state type to conditionally render UI

### 11. Dependency Injection Setup

```dart
// File: lib/main.dart (simplified)

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // 1. Register external dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<http.Client>(http.Client());

  // 2. Register core services
  getIt.registerSingleton<ApiClient>(
    ApiClient(httpClient: getIt<http.Client>()),
  );

  // 3. Register data sources
  getIt.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );
  
  getIt.registerSingleton<AuthLocalDataSource>(
    AuthLocalDataSourceImpl(sharedPreferences: getIt<SharedPreferences>()),
  );

  // 4. Register repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );

  // 5. Register use cases
  getIt.registerSingleton<LoginUseCase>(
    LoginUseCase(getIt<AuthRepository>()),
  );

  // 6. Register BLoCs
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      // ... other use cases
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const MyApp());
}
```

**Key Points:**
- Register dependencies in correct order (from bottom to top of layer pyramid)
- Use `registerSingleton` for single instances (BLoCs, repositories)
- Call `setupDependencies()` before `runApp()`
- Dependencies are accessed via `getIt<Type>()`

### 12. Pagination Implementation

```dart
// Products BLoC example

// Event for initial load
class FetchProductsEvent extends ProductsEvent {
  final int skip;
  final int limit;
  final String? token;

  const FetchProductsEvent({
    required this.skip,
    required this.limit,
    this.token,
  });
}

// Event for loading more
class LoadMoreProductsEvent extends ProductsEvent {
  final int skip;
  final int limit;
  final String? token;

  const LoadMoreProductsEvent({
    required this.skip,
    required this.limit,
    this.token,
  });
}

// Handling initial load
Future<void> _onFetchProducts(
  FetchProductsEvent event,
  Emitter<ProductsState> emit,
) async {
  emit(const ProductsLoading());
  try {
    final response = await getProductsUseCase(
      skip: event.skip,
      limit: event.limit,
      token: event.token,
    );

    final hasMoreData = (event.skip + event.limit) < response.total;
    emit(ProductsLoaded(
      products: response.items,
      total: response.total,
      skip: event.skip,
      limit: event.limit,
      hasMoreData: hasMoreData,
    ));
  } on AppException catch (e) {
    emit(ProductsError(message: e.message));
  }
}

// Handling load more
Future<void> _onLoadMoreProducts(
  LoadMoreProductsEvent event,
  Emitter<ProductsState> emit,
) async {
  if (state is ProductsLoaded) {
    final currentState = state as ProductsLoaded;
    
    if (!currentState.hasMoreData) {
      return; // No more items to load
    }

    emit(ProductsPaginationLoading(
      products: currentState.products,
      total: currentState.total,
      skip: currentState.skip,
      limit: currentState.limit,
    ));

    try {
      final response = await getProductsUseCase(
        skip: event.skip,
        limit: event.limit,
        token: event.token,
      );

      // Combine old + new products
      final allProducts = [...currentState.products, ...response.items];
      final hasMoreData = (event.skip + event.limit) < response.total;

      emit(ProductsLoaded(
        products: allProducts,
        total: response.total,
        skip: event.skip,
        limit: event.limit,
        hasMoreData: hasMoreData,
      ));
    } on AppException catch (e) {
      emit(ProductsError(
        message: e.message,
        previousProducts: currentState.products,
      ));
    }
  }
}

// In screen:
void _onScroll() {
  if (_scrollController.position.pixels >=
      _scrollController.position.maxScrollExtent - 500) {
    final state = context.read<ProductsBloc>().state;
    if (state is ProductsLoaded && state.hasMoreData) {
      context.read<ProductsBloc>().add(
        LoadMoreProductsEvent(
          skip: state.skip + state.limit,
          limit: state.limit,
          token: _userToken,
        ),
      );
    }
  }
}
```

**Key Points:**
- Use separate events for initial load and load more
- Track `hasMoreData` to know if more items exist
- Append new items to existing list
- Show loading indicator for pagination
- Handle errors while showing previous items

---

## Flow Diagrams

### Login Flow
```
User Input
    ↓
LoginEvent (username, password)
    ↓
AuthBloc._onLogin()
    ↓
emit(AuthLoading)
    ↓
LoginUseCase(username, password)
    ↓
AuthRepository.login()
    ↓
AuthRemoteDataSource.login() [API Call]
    ↓
AuthLocalDataSource.saveUser() [Cache]
    ↓
emit(AuthSuccess(user))
    ↓
Navigation to Home
```

### Session Check Flow
```
App Startup
    ↓
CheckSessionEvent
    ↓
AuthBloc._onCheckSession()
    ↓
HasValidSessionUseCase()
    ↓
AuthLocalDataSource.hasValidSession()
    ↓
Check SharedPreferences
    ↓
emit(SessionValid/Invalid)
    ↓
Route to Home/Login
```

### Products Pagination Flow
```
Screen Load
    ↓
FetchProductsEvent(skip=0, limit=10)
    ↓
ProductsBloc._onFetchProducts()
    ↓
emit(ProductsLoading)
    ↓
GetProductsUseCase(skip=0, limit=10)
    ↓
ProductsRepository.getProducts()
    ↓
ProductsRemoteDataSource.getProducts() [API]
    ↓
emit(ProductsLoaded(products=[...], hasMoreData=true))
    ↓
User Scrolls to Bottom
    ↓
LoadMoreProductsEvent(skip=10, limit=10)
    ↓
ProductsBloc._onLoadMoreProducts()
    ↓
emit(ProductsPaginationLoading)
    ↓
GetProductsUseCase(skip=10, limit=10)
    ↓
emit(ProductsLoaded(products=[...old + new...], hasMoreData=true))
```

---

This guide covers all major patterns used in the application. Use these snippets as templates for adding new features!
