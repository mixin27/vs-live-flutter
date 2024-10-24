import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff785a0b),
      surfaceTint: Color(0xff785a0b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffdf9f),
      onPrimaryContainer: Color(0xff261a00),
      secondary: Color(0xff35693e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffb7f1ba),
      onSecondaryContainer: Color(0xff002109),
      tertiary: Color(0xff3c6939),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffbdf0b4),
      onTertiaryContainer: Color(0xff002203),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffff8f2),
      onSurface: Color(0xff1f1b13),
      onSurfaceVariant: Color(0xff4d4639),
      outline: Color(0xff7f7667),
      outlineVariant: Color(0xffd0c5b4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff353027),
      inversePrimary: Color(0xffe9c16c),
      primaryFixed: Color(0xffffdf9f),
      onPrimaryFixed: Color(0xff261a00),
      primaryFixedDim: Color(0xffe9c16c),
      onPrimaryFixedVariant: Color(0xff5c4300),
      secondaryFixed: Color(0xffb7f1ba),
      onSecondaryFixed: Color(0xff002109),
      secondaryFixedDim: Color(0xff9cd4a0),
      onSecondaryFixedVariant: Color(0xff1c5128),
      tertiaryFixed: Color(0xffbdf0b4),
      onTertiaryFixed: Color(0xff002203),
      tertiaryFixedDim: Color(0xffa1d399),
      onTertiaryFixedVariant: Color(0xff245023),
      surfaceDim: Color(0xffe2d9cc),
      surfaceBright: Color(0xfffff8f2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffcf2e5),
      surfaceContainer: Color(0xfff7ecdf),
      surfaceContainerHigh: Color(0xfff1e7d9),
      surfaceContainerHighest: Color(0xffebe1d4),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff573f00),
      surfaceTint: Color(0xff785a0b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff907023),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff184d25),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff4c8053),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff204c20),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff527f4d),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f2),
      onSurface: Color(0xff1f1b13),
      onSurfaceVariant: Color(0xff494235),
      outline: Color(0xff665e50),
      outlineVariant: Color(0xff837a6b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff353027),
      inversePrimary: Color(0xffe9c16c),
      primaryFixed: Color(0xff907023),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff755708),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff4c8053),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff33673c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff527f4d),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff396637),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe2d9cc),
      surfaceBright: Color(0xfffff8f2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffcf2e5),
      surfaceContainer: Color(0xfff7ecdf),
      surfaceContainerHigh: Color(0xfff1e7d9),
      surfaceContainerHighest: Color(0xffebe1d4),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff2e2000),
      surfaceTint: Color(0xff785a0b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff573f00),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff00290c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff184d25),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff002905),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff204c20),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f2),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff292318),
      outline: Color(0xff494235),
      outlineVariant: Color(0xff494235),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff353027),
      inversePrimary: Color(0xffffeac4),
      primaryFixed: Color(0xff573f00),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff3b2a00),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff184d25),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff003512),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff204c20),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff06350b),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe2d9cc),
      surfaceBright: Color(0xfffff8f2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffcf2e5),
      surfaceContainer: Color(0xfff7ecdf),
      surfaceContainerHigh: Color(0xfff1e7d9),
      surfaceContainerHighest: Color(0xffebe1d4),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe9c16c),
      surfaceTint: Color(0xffe9c16c),
      onPrimary: Color(0xff402d00),
      primaryContainer: Color(0xff5c4300),
      onPrimaryContainer: Color(0xffffdf9f),
      secondary: Color(0xff9cd4a0),
      onSecondary: Color(0xff003914),
      secondaryContainer: Color(0xff1c5128),
      onSecondaryContainer: Color(0xffb7f1ba),
      tertiary: Color(0xffa1d399),
      onTertiary: Color(0xff0b390f),
      tertiaryContainer: Color(0xff245023),
      onTertiaryContainer: Color(0xffbdf0b4),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff17130b),
      onSurface: Color(0xffebe1d4),
      onSurfaceVariant: Color(0xffd0c5b4),
      outline: Color(0xff998f80),
      outlineVariant: Color(0xff4d4639),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffebe1d4),
      inversePrimary: Color(0xff785a0b),
      primaryFixed: Color(0xffffdf9f),
      onPrimaryFixed: Color(0xff261a00),
      primaryFixedDim: Color(0xffe9c16c),
      onPrimaryFixedVariant: Color(0xff5c4300),
      secondaryFixed: Color(0xffb7f1ba),
      onSecondaryFixed: Color(0xff002109),
      secondaryFixedDim: Color(0xff9cd4a0),
      onSecondaryFixedVariant: Color(0xff1c5128),
      tertiaryFixed: Color(0xffbdf0b4),
      onTertiaryFixed: Color(0xff002203),
      tertiaryFixedDim: Color(0xffa1d399),
      onTertiaryFixedVariant: Color(0xff245023),
      surfaceDim: Color(0xff17130b),
      surfaceBright: Color(0xff3e382f),
      surfaceContainerLowest: Color(0xff110e07),
      surfaceContainerLow: Color(0xff1f1b13),
      surfaceContainer: Color(0xff241f17),
      surfaceContainerHigh: Color(0xff2e2921),
      surfaceContainerHighest: Color(0xff39342b),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffeec570),
      surfaceTint: Color(0xffe9c16c),
      onPrimary: Color(0xff1f1500),
      primaryContainer: Color(0xffaf8c3d),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffa0d8a4),
      onSecondary: Color(0xff001b06),
      secondaryContainer: Color(0xff679d6d),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffa5d89d),
      onTertiary: Color(0xff001c02),
      tertiaryContainer: Color(0xff6d9c67),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff17130b),
      onSurface: Color(0xfffffaf7),
      onSurfaceVariant: Color(0xffd5c9b8),
      outline: Color(0xffaca291),
      outlineVariant: Color(0xff8b8273),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffebe1d4),
      inversePrimary: Color(0xff5d4400),
      primaryFixed: Color(0xffffdf9f),
      onPrimaryFixed: Color(0xff191000),
      primaryFixedDim: Color(0xffe9c16c),
      onPrimaryFixedVariant: Color(0xff473300),
      secondaryFixed: Color(0xffb7f1ba),
      onSecondaryFixed: Color(0xff001504),
      secondaryFixedDim: Color(0xff9cd4a0),
      onSecondaryFixedVariant: Color(0xff063f19),
      tertiaryFixed: Color(0xffbdf0b4),
      onTertiaryFixed: Color(0xff001602),
      tertiaryFixedDim: Color(0xffa1d399),
      onTertiaryFixedVariant: Color(0xff123f14),
      surfaceDim: Color(0xff17130b),
      surfaceBright: Color(0xff3e382f),
      surfaceContainerLowest: Color(0xff110e07),
      surfaceContainerLow: Color(0xff1f1b13),
      surfaceContainer: Color(0xff241f17),
      surfaceContainerHigh: Color(0xff2e2921),
      surfaceContainerHighest: Color(0xff39342b),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffffaf7),
      surfaceTint: Color(0xffe9c16c),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffeec570),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfff0ffec),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffa0d8a4),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff1ffe9),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffa5d89d),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff17130b),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffffaf7),
      outline: Color(0xffd5c9b8),
      outlineVariant: Color(0xffd5c9b8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffebe1d4),
      inversePrimary: Color(0xff382700),
      primaryFixed: Color(0xffffe4b0),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffeec570),
      onPrimaryFixedVariant: Color(0xff1f1500),
      secondaryFixed: Color(0xffbbf5be),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffa0d8a4),
      onSecondaryFixedVariant: Color(0xff001b06),
      tertiaryFixed: Color(0xffc1f4b8),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffa5d89d),
      onTertiaryFixedVariant: Color(0xff001c02),
      surfaceDim: Color(0xff17130b),
      surfaceBright: Color(0xff3e382f),
      surfaceContainerLowest: Color(0xff110e07),
      surfaceContainerLow: Color(0xff1f1b13),
      surfaceContainer: Color(0xff241f17),
      surfaceContainerHigh: Color(0xff2e2921),
      surfaceContainerHighest: Color(0xff39342b),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
