import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/api_constants.dart';
import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/local/auth_local_datasource.dart';
import 'data/datasources/remote/auth_remote_datasource.dart';
import 'data/datasources/remote/posts_remote_datasource.dart';
import 'data/datasources/remote/products_remote_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/posts_repository_impl.dart';
import 'data/repositories/products_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/posts_repository.dart';
import 'domain/repositories/products_repository.dart';
import 'domain/usecases/auth/auth_usecases.dart';
import 'domain/usecases/posts/get_posts_usecase.dart';
import 'domain/usecases/products/get_products_usecase.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/auth/auth_event.dart';
import 'presentation/bloc/posts/posts_bloc.dart';
import 'presentation/bloc/products/products_bloc.dart';
import 'presentation/bloc/theme/theme_bloc.dart';
import 'presentation/bloc/theme/theme_event.dart';
import 'presentation/bloc/theme/theme_state.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/bloc/auth/auth_state.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<http.Client>(http.Client());

  // Core
  getIt.registerSingleton<ApiClient>(
    ApiClient(httpClient: getIt<http.Client>()),
  );

  // Data Sources
  getIt.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  getIt.registerSingleton<AuthLocalDataSource>(
    AuthLocalDataSourceImpl(sharedPreferences: getIt<SharedPreferences>()),
  );

  getIt.registerSingleton<ProductsRemoteDataSource>(
    ProductsRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  getIt.registerSingleton<PostsRemoteDataSource>(
    PostsRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );

  getIt.registerSingleton<ProductsRepository>(
    ProductsRepositoryImpl(
      remoteDataSource: getIt<ProductsRemoteDataSource>(),
    ),
  );

  getIt.registerSingleton<PostsRepository>(
    PostsRepositoryImpl(
      remoteDataSource: getIt<PostsRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerSingleton<LoginUseCase>(
    LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerSingleton<GetCachedUserUseCase>(
    GetCachedUserUseCase(getIt<AuthRepository>()),
  );

  getIt.registerSingleton<LogoutUseCase>(
    LogoutUseCase(getIt<AuthRepository>()),
  );

  getIt.registerSingleton<HasValidSessionUseCase>(
    HasValidSessionUseCase(getIt<AuthRepository>()),
  );

  getIt.registerSingleton<GetProductsUseCase>(
    GetProductsUseCase(getIt<ProductsRepository>()),
  );

  getIt.registerSingleton<GetPostsUseCase>(
    GetPostsUseCase(getIt<PostsRepository>()),
  );

  // BLoCs
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      getCachedUserUseCase: getIt<GetCachedUserUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      hasValidSessionUseCase: getIt<HasValidSessionUseCase>(),
    ),
  );

  getIt.registerSingleton<ThemeBloc>(
    ThemeBloc(sharedPreferences: getIt<SharedPreferences>()),
  );

  getIt.registerSingleton<ProductsBloc>(
    ProductsBloc(getProductsUseCase: getIt<GetProductsUseCase>()),
  );

  getIt.registerSingleton<PostsBloc>(
    PostsBloc(getPostsUseCase: getIt<GetPostsUseCase>()),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Check for existing session on app startup
    getIt<AuthBloc>().add(const CheckSessionEvent());
    // Initialize theme
    getIt<ThemeBloc>().add(const InitializeThemeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: getIt<AuthBloc>()),
        BlocProvider<ThemeBloc>.value(value: getIt<ThemeBloc>()),
        BlocProvider<ProductsBloc>.value(value: getIt<ProductsBloc>()),
        BlocProvider<PostsBloc>.value(value: getIt<PostsBloc>()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Taghyeer',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                if (authState is SessionValid) {
                  return HomeScreen(user: authState.user);
                } else if (authState is AuthSuccess) {
                  return HomeScreen(user: authState.user);
                } else {
                  return const LoginScreen();
                }
              },
            ),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/home': (context) {
                final authState = context.read<AuthBloc>().state;
                if (authState is AuthSuccess) {
                  return HomeScreen(user: authState.user);
                } else if (authState is SessionValid) {
                  return HomeScreen(user: authState.user);
                } else {
                  return const LoginScreen();
                }
              },
            },
          );
        },
      ),
    );
  }
}
