import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vs_live/src/config/themes/app_theme.dart';
import 'package:vs_live/src/providers/app_theme_provider.dart';
import 'package:vs_live/src/routing/app_router.dart';
import 'package:vs_live/src/update/presentation/force_update_widget.dart';
import 'package:vs_live/src/update/utils/force_update_client.dart';
import 'package:vs_live/src/utils/ads/app_open_ad_widget.dart';
import 'package:vs_live/src/utils/remote_config/remote_config.dart';
import 'package:vs_live/src/widgets/dialog/show_alert_dialog.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      title: 'VS Football Live',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      builder: (context, child) {
        return ForceUpdateWidget(
          navigatorKey: rootNavigatorKey,
          forceUpdateClient: ForceUpdateClient(
            fetchRequiredVersion: () async {
              // * Fetch remote config from an API endpoint.
              // * Alternatively, you can use Firebase Remote Config
              // final client = RemoteConfigGistClient(dio: Dio());
              // final remoteConfig = await client.fetchRemoteConfig();
              // return remoteConfig.requiredVersion;
              return AppRemoteConfig.latestVersion;
            },
            iosAppStoreId: '',
          ),
          allowCancel: !AppRemoteConfig.forceUpdate,
          showForceUpdateAlert: (context, allowCancel) {
            log("show update dialog");
            return showAlertDialog(
              context: context,
              title: 'App Update Required',
              content: 'Please update to continue using the app.',
              cancelActionText: allowCancel ? 'Later' : null,
              defaultActionText: 'Update Now',
            );
          },
          showStoreListing: (storeUrl) async {
            if (await canLaunchUrl(storeUrl)) {
              await launchUrl(
                storeUrl,
                // * Open app store app directly (or fallback to browser)
                mode: LaunchMode.externalApplication,
              );
            } else {
              log('Cannot launch URL: $storeUrl');
            }
          },
          onException: (e, st) {
            log(e.toString());
          },
          child: AppOpenAdWidget(child: child!),
        );
      },
    );
  }
}
