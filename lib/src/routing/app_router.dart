import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vs_live/src/features/home/presentation/home_screen.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/features/live_match/presentation/live_match_detail/live_match_detail_screen.dart';
import 'package:vs_live/src/features/live_match/presentation/live_match_list/live_match_screen.dart';
import 'package:vs_live/src/features/onboarding/data/onboarding_repository.dart';
import 'package:vs_live/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:vs_live/src/routing/not_found_screen.dart';

import 'app_startup.dart';
import 'scaffold_with_nested_navigation.dart';

part 'app_router.g.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _liveMatchNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'live-matches');

enum AppRoute {
  onboarding,
  home,
  liveMatch,
  liveMatchDetail,
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  // rebuild GoRouter when app startup state changes
  final appStartupState = ref.watch(appStartupProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/live-matches',
    debugLogDiagnostics: !kReleaseMode,
    redirect: (context, state) {
      // If the app is still initializing, show the /startup route
      if (appStartupState.isLoading || appStartupState.hasError) {
        return '/startup';
      }

      final onboardingRepository =
          ref.read(onboardingRepositoryProvider).requireValue;
      final didCompleteOnboarding = onboardingRepository.isOnboardingComplete();
      final path = state.uri.path;
      if (!didCompleteOnboarding) {
        // Always check state.subloc before returning a non-null route
        // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart#L78
        if (path != '/onboarding') {
          return '/onboarding';
        }

        if (path.startsWith('/startup') || path.startsWith('/onboarding')) {
          return '/live-matches';
        }
        return null;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/startup',
        pageBuilder: (context, state) => NoTransitionPage(
          child: AppStartupWidget(
            // * This is just a placeholder
            // * The loaded route will be managed by GoRouter on state change
            onLoaded: (_) => const SizedBox.shrink(),
          ),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        name: AppRoute.onboarding.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: HomeScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) => NoTransitionPage(
          child: ScaffoldWithNestedNavigation(navigationShell: navigationShell),
        ),
        branches: [
          StatefulShellBranch(
            navigatorKey: _liveMatchNavigatorKey,
            routes: [
              GoRoute(
                path: '/live-matches',
                name: AppRoute.liveMatch.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: LiveMatchScreen(),
                ),
                routes: [
                  GoRoute(
                    path: '/details',
                    name: AppRoute.liveMatchDetail.name,
                    pageBuilder: (context, state) {
                      LiveMatch match = state.extra as LiveMatch;
                      return NoTransitionPage(
                        child: LiveMatchDetailScreen(match: match),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) => const NoTransitionPage(
      child: NotFoundScreen(),
    ),
  );
}
