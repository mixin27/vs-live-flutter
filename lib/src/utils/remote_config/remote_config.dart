import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

const _isDebug = kDebugMode || kProfileMode;

class AppRemoteConfig {
  static final _config = FirebaseRemoteConfig.instance;

  static const _defaultValues = {
    "live_match_list_page":
        "{     \"native\": true,     \"banner\": true,     \"interstitial\": true,     \"rewarded\": true }",
    "live_match_detail_page":
        "{     \"native\": true,     \"banner\": true,     \"interstitial\": true,     \"rewarded\": true }",
    "highlight_list_page":
        "{     \"native\": true,     \"banner\": true,     \"interstitial\": true,     \"rewarded\": true }",
    "banner_ad": "ca-app-pub-7567997114394639/8648546201",
    "interstitial_ad": "ca-app-pub-7567997114394639/1475405831",
    "native_ad": "ca-app-pub-7567997114394639/9425876604",
    "rewarded_ad": "ca-app-pub-7567997114394639/8288226195",
    "show_ads": true,
    "app_open_ad": "ca-app-pub-7567997114394639/7748304172",
    "show_app_open_ad": true,
    "show_banner_ad": true,
    "show_native_ad": true,
    "show_interstitial_ad": true,
    "show_rewarded_ad": true,
    "show_ads_in_match_list": true,
    "show_ads_in_match_detail": true,
    "show_ads_in_highlight_list": true,
    "latest_build": 10,
    "latest_version": "1.0.9",
    "force_update": true
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

  // page ads show/hide
  static Map<String, dynamic> get _liveMatchListPage =>
      jsonDecode(_config.getString("live_match_list_page"))
          as Map<String, dynamic>;
  static PageAdsInfo get liveMatchListAdsInfo =>
      PageAdsInfo.fromJson(_liveMatchListPage);

  static Map<String, dynamic> get _liveMatchDetailPage =>
      jsonDecode(_config.getString("live_match_detail_page"))
          as Map<String, dynamic>;
  static PageAdsInfo get liveMatchDetailAdsInfo =>
      PageAdsInfo.fromJson(_liveMatchDetailPage);

  static Map<String, dynamic> get _highlightListPage =>
      jsonDecode(_config.getString("highlight_list_page"))
          as Map<String, dynamic>;
  static PageAdsInfo get highlightListAdsInfo =>
      PageAdsInfo.fromJson(_highlightListPage);

  // show/hide for specific page
  static bool get _showAdsInMatchList =>
      _config.getBool("show_ads_in_match_list");
  static bool get hideAdsInMatchList => !_showAdsInMatchList;

  static bool get _showAdsInMatchDetail =>
      _config.getBool("show_ads_in_match_detail");
  static bool get hideAdsInMatchDetail => !_showAdsInMatchDetail;

  static bool get _showAdsInHighlightList =>
      _config.getBool("show_ads_in_highlight_list");
  static bool get hideAdsInHighlightList => !_showAdsInHighlightList;

  // show/hide for specific ads type
  static bool get _showAppOpenAd => _config.getBool("show_app_open_ad");
  static bool get hideAppOpenAd => !_showAppOpenAd;

  static bool get _showBannerAd => _config.getBool("show_banner_ad");
  static bool get hideBannerAd => !_showBannerAd;

  static bool get _showNativeAd => _config.getBool("show_native_ad");
  static bool get hideNativeAd => !_showNativeAd;

  static bool get _showInterstitialAd =>
      _config.getBool("show_interstitial_ad");
  static bool get hideInterstitialAd => _showInterstitialAd;

  static bool get _showRewardedAd => _config.getBool("show_rewarded_ad");
  static bool get hideRewardedAd => !_showRewardedAd;

  // ad ids
  static String get _nativeAd => _config.getString('native_ad');
  static String get nativeAd =>
      _isDebug ? "ca-app-pub-3940256099942544/2247696110" : _nativeAd;

  static String get _bannerAd => _config.getString('banner_ad');
  static String get bannerAd =>
      _isDebug ? "ca-app-pub-3940256099942544/9214589741" : _bannerAd;

  static String get _interstitialAd => _config.getString('interstitial_ad');
  static String get interstitialAd =>
      _isDebug ? "ca-app-pub-3940256099942544/1033173712" : _interstitialAd;

  static String get _rewardedAd => _config.getString('rewarded_ad');
  static String get rewardedAd =>
      _isDebug ? "ca-app-pub-3940256099942544/5224354917" : _rewardedAd;

  static String get _appOpenAd => _config.getString('app_open_ad');
  static String get appOpenAd =>
      _isDebug ? "ca-app-pub-3940256099942544/9257395921" : _appOpenAd;

  // app update
  static int get latestBuildNumber => _config.getInt('latest_build');
  static String get latestVersion => _config.getString('latest_version');
  static bool get forceUpdate => _config.getBool('force_update');
}

class PageAdsInfo extends Equatable {
  const PageAdsInfo({
    required this.native,
    required this.banner,
    required this.interstitial,
    required this.rewarded,
  });

  final bool native;
  final bool banner;
  final bool interstitial;
  final bool rewarded;

  factory PageAdsInfo.fromJson(Map<String, dynamic> json) => PageAdsInfo(
        banner: json['banner'] as bool? ?? true,
        native: json['native'] as bool? ?? true,
        interstitial: json['interstitial'] as bool? ?? true,
        rewarded: json['rewarded'] as bool? ?? true,
      );

  @override
  List<Object?> get props => [banner, native, interstitial, rewarded];
}
