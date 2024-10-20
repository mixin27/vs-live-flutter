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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LiveMatchScreen(),
      // routerConfig: goRouter,
    );
  }
}
