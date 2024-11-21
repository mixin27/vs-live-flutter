import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class AppRemoteConfig {
  static final _config = FirebaseRemoteConfig.instance;

  static const _defaultValues = {
    "latest_build": 1,
    "latest_version": "1.0.0",
    "force_update": false,
    "banner_ad": "ca-app-pub-7567997114394639/8648546201",
    "interstitial_ad": "ca-app-pub-7567997114394639/1475405831",
    "native_ad": "ca-app-pub-7567997114394639/9425876604",
    "rewarded_ad": "ca-app-pub-7567997114394639/8288226195",
    "show_ads": true,
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
  static String get nativeId => !kReleaseMode
      ? "ca-app-pub-3940256099942544/2247696110"
      : _config.getString('native_ad');
  static String get bannerId => !kReleaseMode
      ? "ca-app-pub-3940256099942544/9214589741"
      : _config.getString('banner_ad');
  static String get interstitialId => !kReleaseMode
      ? "ca-app-pub-3940256099942544/1033173712"
      : _config.getString('interstitial_ad');
  static String get rewardedId =>
      !kReleaseMode ? "" : _config.getString('rewarded_ad');

  // app update
  static int get latestBuildNumber => _config.getInt('latest_build');
  static String get latestVersion => _config.getString('latest_version');
  static bool get forceUpdate => _config.getBool('force_update');
}
