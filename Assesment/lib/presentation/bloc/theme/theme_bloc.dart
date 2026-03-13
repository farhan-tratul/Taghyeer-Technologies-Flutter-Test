import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/theme/app_theme.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences sharedPreferences;

  ThemeBloc({required this.sharedPreferences})
      : super(
        LightThemeState(themeData: AppTheme.lightTheme),
      ) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<InitializeThemeEvent>(_onInitializeTheme);
  }

  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final isDarkMode = !state.isDarkMode;
    
    // Save to SharedPreferences
    await sharedPreferences.setBool(StorageConstants.themeKey, isDarkMode);

    if (isDarkMode) {
      emit(DarkThemeState(themeData: AppTheme.darkTheme));
    } else {
      emit(LightThemeState(themeData: AppTheme.lightTheme));
    }
  }

  Future<void> _onInitializeTheme(
    InitializeThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final isDarkMode = sharedPreferences.getBool(StorageConstants.themeKey) ?? false;

    if (isDarkMode) {
      emit(DarkThemeState(themeData: AppTheme.darkTheme));
    } else {
      emit(LightThemeState(themeData: AppTheme.lightTheme));
    }
  }
}
