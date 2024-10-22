import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/features/live_match/presentation/live_match_list/live_match_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final goRouter = ref.watch(goRouterProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VS Football Live',
      theme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFFe9c16c),
          primary: const Color(0xFFe9c16c),
          onPrimary: const Color(0xFF402d00),
          secondary: const Color(0xFF9cd49f),
          onSecondary: const Color(0xFF003914),
          tertiary: const Color(0xFFb1cfa9),
          onTertiary: const Color(0xFF1d361b),
          primaryContainer: const Color(0xFF5c4300),
          onPrimaryContainer: const Color(0xFFffdf9f),
          secondaryContainer: const Color(0xFF1c5128),
          onSecondaryContainer: const Color(0xFFb7f1ba),
          surfaceDim: const Color(0xFF17130b),
          surface: const Color(0xFF17130b),
          onSurface: const Color(0xFFebe1d4),
          surfaceBright: const Color(0xFF3e382f),
        ),
      ),
      home: const LiveMatchScreen(),
      // routerConfig: goRouter,
    );
  }
}
