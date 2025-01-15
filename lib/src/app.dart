import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vs_live/src/config/env.dart';
import 'package:vs_live/src/config/themes/app_theme.dart';
import 'package:vs_live/src/providers/app_theme_provider.dart';
import 'package:vs_live/src/routing/app_router.dart';
import 'package:vs_live/src/routing/app_startup.dart';
import 'package:vs_live/src/update/presentation/force_update_widget.dart';
import 'package:vs_live/src/update/utils/force_update_client.dart';
import 'package:vs_live/src/utils/ads/app_open_ad_widget.dart';
import 'package:vs_live/src/utils/remote_config/remote_config.dart';
import 'package:vs_live/src/widgets/dialog/show_alert_dialog.dart';
import 'package:wiredash/wiredash.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);
    final goRouter = ref.watch(goRouterProvider);

    return Wiredash(
      projectId: Env.wiredashProjectId,
      secret: Env.wiredashSecret,
      feedbackOptions: const WiredashFeedbackOptions(
        labels: [
          Label(id: 'label-44n9u50cx5', title: "Improvement"),
          Label(id: 'label-robggxfgqt', title: "Bug"),
          Label(id: 'label-eenm573wvf', title: "Praise"),
          Label(id: 'label-qj74vhjvtn', title: "Feature Request"),
          Label(id: 'label-uudlo878qu', title: "Stream Link"),
        ],
      ),
      child: MaterialApp.router(
        routerConfig: goRouter,
        debugShowCheckedModeBanner: false,
        // useInheritedMediaQuery: true,
        title: 'Billion Sport Live',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        locale: DevicePreview.locale(context),
        builder: (context, child) {
          return DevicePreview.appBuilder(
            context,
            AppStartupWidget(
              onLoaded: (_) => ForceUpdateWidget(
                navigatorKey: rootNavigatorKey,
                forceUpdateClient: ForceUpdateClient(
                  fetchRequiredVersion: () async {
                    return AppRemoteConfig.latestVersion;
                  },
                  iosAppStoreId: '',
                ),
                allowCancel: !AppRemoteConfig.forceUpdate,
                showForceUpdateAlert: (context, allowCancel) {
                  log("show update dialog");
                  return showAlertDialog(
                    context: context,
                    title: AppRemoteConfig.updateTitle,
                    content: AppRemoteConfig.updateDescription,
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
              ),
            ),
          );
        },
      ),
    );
  }
}
