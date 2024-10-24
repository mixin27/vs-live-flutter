import 'package:flutter/material.dart';

import 'theme.dart';

class AppTheme {
  static ThemeData get light => ThemeData.light(
        useMaterial3: true,
      ).copyWith(
        colorScheme: MaterialTheme.lightScheme(),
      );

  static ThemeData get dark => ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        colorScheme: MaterialTheme.darkScheme(),
      );
}
