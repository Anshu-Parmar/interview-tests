import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/core/configs/theme/app_theme.dart';
import 'package:startopreneur/core/source/shared_preferences_services.dart';

class ThemesCubit extends Cubit<ThemeData> {
  ThemeMode themeModeSave = ThemeMode.system;
  ThemesCubit() : super(AppTheme.lightTheme) {
    _loadTheme();
  }

  Future<AppThemeMode> _loadTheme() async {
    final themeMode = await SharedPreferencesService.getTheme();
    _saveThemeMode(themeMode);
    _applyTheme(themeMode);
    return themeMode;
  }

  void toggleTheme(AppThemeMode themeMode, {Brightness? brightnessData}) {
    _saveThemeMode(themeMode);
    _applyTheme(themeMode);
    SharedPreferencesService.saveTheme(themeMode);
  }

  ThemeMode? _saveThemeMode(AppThemeMode themeMode) {
    switch(themeMode){
      case AppThemeMode.system:
        themeModeSave = ThemeMode.system;
      case AppThemeMode.light:
        themeModeSave = ThemeMode.light;
      case AppThemeMode.dark:
        themeModeSave = ThemeMode.dark;
    }
    return themeModeSave;
  }

  void _applyTheme(AppThemeMode themeMode) {
    switch (themeMode) {
      case AppThemeMode.system:
        final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
        emit(brightness == Brightness.light ? AppTheme.lightTheme : AppTheme.darkTheme);
        break;
      case AppThemeMode.light:
        emit(AppTheme.lightTheme);
        break;
      case AppThemeMode.dark:
        emit(AppTheme.darkTheme);
        break;
    }
  }
}