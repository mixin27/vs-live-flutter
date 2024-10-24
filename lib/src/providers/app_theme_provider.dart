import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vs_live/src/utils/prefs_manager.dart';

part 'app_theme_provider.g.dart';

const PreferenceKey keyTheme = 'key_theme';

@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  ThemeMode _getCachedThemeMode() {
    final prefs = ref.read(preferenceManagerProvider);

    final mode = prefs.getData<String>(keyTheme);
    log(mode.toString());

    return switch (mode) {
      'ThemeMode.dark' => ThemeMode.dark,
      'ThemeMode.light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }

  @override
  ThemeMode build() {
    return _getCachedThemeMode();
  }

  void setThemeMode(ThemeMode mode) {
    final prefs = ref.read(preferenceManagerProvider);
    prefs.setData<String>(mode.toString(), keyTheme);

    state = _getCachedThemeMode();
  }
}
