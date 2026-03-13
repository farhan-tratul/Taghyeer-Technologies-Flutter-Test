import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeState extends Equatable {
  final bool isDarkMode;
  final ThemeData themeData;

  const ThemeState({
    required this.isDarkMode,
    required this.themeData,
  });

  @override
  List<Object?> get props => [isDarkMode, themeData];
}

class LightThemeState extends ThemeState {
  const LightThemeState({required ThemeData themeData})
      : super(isDarkMode: false, themeData: themeData);
}

class DarkThemeState extends ThemeState {
  const DarkThemeState({required ThemeData themeData})
      : super(isDarkMode: true, themeData: themeData);
}
