import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_mode_state.dart';

class ThemeModeCubit extends Cubit<ThemeModeState> {
  ThemeModeCubit() : super(ThemeModeSystem());

  updateThemeMode(ThemeMode? themeMode){
    switch (themeMode) {
      case ThemeMode.system:
        emit(ThemeModeSystem());
      case ThemeMode.light:
        emit(ThemeModeLight());
      case ThemeMode.dark:
        emit(ThemeModeDark());
      case null:
        emit(ThemeModeSystem());
    }
  }
}
