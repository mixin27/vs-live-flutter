import 'package:flutter/material.dart';
import 'package:vs_live/src/utils/ads/ad_helper.dart';
import 'package:vs_live/src/utils/remote_config/remote_config.dart';

import 'app_life_cycle_reactor.dart';
import 'app_open_ad_manager.dart';

class AppOpenAdWidget extends StatefulWidget {
  const AppOpenAdWidget({super.key, required this.child});

  final Widget child;

  @override
  State<AppOpenAdWidget> createState() => _AppOpenAdWidgetState();
}

class _AppOpenAdWidgetState extends State<AppOpenAdWidget> {
  late AppLifecycleReactor _appLifecycleReactor;
  final AppOpenAdManager _appOpenAdManager = AppOpenAdManager();

  @override
  void initState() {
    super.initState();

    if (AppRemoteConfig.hideAds) return;

    AdHelper.showConsentUMP();

    if (!AppRemoteConfig.hideAppOpenAdListener) {
      _appOpenAdManager.loadAd(onAdLoaded: () {
        _appOpenAdManager.showAdIfAvailable();
      });

      _appLifecycleReactor = AppLifecycleReactor(
        appOpenAdManager: _appOpenAdManager,
      );
      _appLifecycleReactor.listenToAppStateChanges();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
