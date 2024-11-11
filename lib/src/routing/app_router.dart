import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vs_live/src/features/football_highlight/presentation/feed/highlight_feed_screen.dart';
import 'package:vs_live/src/features/football_highlight/presentation/highlight_player_screen/highlight_player_screen.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/features/live_match/presentation/live_match_detail/live_match_detail_screen.dart';
import 'package:vs_live/src/features/live_match/presentation/live_match_list/live_match_screen.dart';
import 'package:vs_live/src/features/live_match/presentation/live_match_player/live_match_player_screen.dart';
import 'package:vs_live/src/features/onboarding/data/onboarding_repository.dart';
import 'package:vs_live/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:vs_live/src/features/settings/presentation/app_settings/settings_screen.dart';
import 'package:vs_live/src/features/settings/presentation/privacy_policy/privacy_policy_screen.dart';
import 'package:vs_live/src/routing/not_found_screen.dart';
import 'package:vs_live/src/widgets/video_player/adaptive_video_player.dart';

import 'app_startup.dart';

part 'app_router.g.dart';

// private navigators
final _rootNavigatorKey = GlobalKey<NavigatorState>();

enum AppRoute {
  onboarding,
  home,
  liveMatchDetail,
  player,
  settings,
  privacyPolicy,
  highlights,
  highlightPlayer
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  // rebuild GoRouter when app startup state changes
  final appStartupState = ref.watch(appStartupProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
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
        return null;
      }

      if (path.startsWith('/startup') || path.startsWith('/onboarding')) {
        return '/home';
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
        path: '/home',
        name: AppRoute.home.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LiveMatchScreen(),
        ),
        routes: [
          GoRoute(
            path: 'detail',
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
      GoRoute(
        path: '/player',
        name: AppRoute.player.name,
        pageBuilder: (context, state) {
          // final extra = state.extra as Map<String, dynamic>;
          final videoUrl = state.uri.queryParameters["videoUrl"];
          final videoType = state.uri.queryParameters["videoType"]!;
          return NoTransitionPage(
            child: LiveMatchPlayerScreen(
              videoUrl: videoUrl ?? '',
              videoType: videoType.getVideoType(),
            ),
          );
        },
      ),
      GoRoute(
        path: '/settings',
        name: AppRoute.settings.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SettingsScreen(),
        ),
        routes: [
          GoRoute(
            path: 'privacy-policy',
            name: AppRoute.privacyPolicy.name,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PrivacyPolicyPage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/highlights',
        name: AppRoute.highlights.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: HighlightFeedScreen(),
        ),
      ),
      GoRoute(
        path: '/highlight-player',
        name: AppRoute.highlightPlayer.name,
        pageBuilder: (context, state) {
          // final extra = state.extra as Map<String, dynamic>;
          final embedVideo = state.uri.queryParameters["embedVideo"];
          return NoTransitionPage(
            child: HighlightPlayerScreen(
              embedVideo: embedVideo ?? '',
            ),
          );
        },
      ),
    ],
    errorPageBuilder: (context, state) => const NoTransitionPage(
      child: NotFoundScreen(),
    ),
  );
}
