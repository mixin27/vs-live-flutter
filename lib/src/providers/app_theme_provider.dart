import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_theme_provider.g.dart';

const String themePrefsKey = "theme_mode";

@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  Future<ThemeMode> _getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();

    final theme = prefs.getString(themePrefsKey);
    if (theme == null) {
      prefs.setString(themePrefsKey, ThemeMode.system.toString());
      return ThemeMode.system;
    }

    return switch (theme) {
      "ThemeMode.dark" => ThemeMode.dark,
      "ThemeMode.light" => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }

  @override
  ThemeMode build() {
    ThemeMode themeMode = ThemeMode.system;
    _getThemeMode().then((value) {
      themeMode = value;
    });
    return themeMode;
  }

  Future<void> changeTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(themePrefsKey, mode.toString());
    state = mode;
  }
}
