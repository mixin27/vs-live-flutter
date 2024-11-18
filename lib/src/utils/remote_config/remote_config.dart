import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class AppRemoteConfig {
  static final _config = FirebaseRemoteConfig.instance;

  static const _defaultValues = {
    "banner_ad": "ca-app-pub-7567997114394639/8648546201",
    "interstitial_ad": "ca-app-pub-7567997114394639/1475405831",
    "native_ad": "ca-app-pub-7567997114394639/9425876604",
    "rewarded_ad": "ca-app-pub-7567997114394639/8288226195",
    "show_ads": true,
    "latest_build": 1,
    "latest_version": "1.0.0",
  };

  static Future<void> initConfig() async {
    await _config.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 30),
      ),
    );

    await _config.setDefaults(_defaultValues);
    await _config.fetchAndActivate();
    log('remoteConfigData: ${_config.getBool("show_ads")}');

    _config.onConfigUpdated.listen((event) async {
      await _config.activate();
      log('updated: ${_config.getBool("show_ads")}');
    });
  }

  static bool get _showAds => _config.getBool('show_ads');
  static bool get hideAds => !_showAds;

  // ad ids
  static String get nativeId => _config.getString('native_ad');
  static String get bannerId => _config.getString('banner_ad');
  static String get interstitialId => _config.getString('interstitial_ad');
  static String get rewardedId => _config.getString('rewarded_ad');

  // app update
  static int get latestBuildNumber => _config.getInt('latest_build');
  static String get latestVersion => _config.getString('latest_version');
}
