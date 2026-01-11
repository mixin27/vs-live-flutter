import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:vs_live/src/config/env.dart';

class AppRemoteConfig {
  static final _config = FirebaseRemoteConfig.instance;

  static final _defaultValues = {
    "live_match_list_page":
        "{     \"native\": true,     \"banner\": true,     \"interstitial\": true,     \"rewarded\": true }",
    "live_match_detail_page":
        "{     \"native\": true,     \"banner\": true,     \"interstitial\": true,     \"rewarded\": true }",
    "highlight_list_page":
        "{     \"native\": true,     \"banner\": true,     \"interstitial\": true,     \"rewarded\": true }",
    "show_ads": true,
    "show_app_open_ad": true,
    "show_banner_ad": true,
    "show_native_ad": true,
    "show_interstitial_ad": true,
    "show_rewarded_ad": true,
    "show_ads_in_match_list": true,
    "show_ads_in_match_detail": true,
    "show_ads_in_highlight_list": true,
    "show_app_open_listener": true,
    "latest_version": "1.0.9",
    "force_update": true,
    "update_title": "App Update Required",
    "update_description": "Please update to continue using the app.",
    "download_link": "https://github.com/mixin27/vs-live-flutter/releases",
    "api_url": Env.baseUrl,
    "api_key": "blablabla",
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

    log('remoteConfigData: ${_config.getString("api_url")}');

    _config.onConfigUpdated.listen((event) async {
      await _config.activate();
      log('updated: ${_config.getBool("show_ads")}');
    });
  }

  static String get updateTitle => _config.getString("update_title");
  static String get updateDescription =>
      _config.getString("update_description");

  // static String get apiUrl => _config.getString("api_url");
  // static String get apiKey => _config.getString("api_key");

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
  static bool get _showAppOpenAdListener =>
      _config.getBool('show_app_open_listener');
  static bool get hideAppOpenAdListener => !_showAppOpenAdListener;

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

  // app update
  static String get latestVersion => _config.getString('latest_version');
  static bool get forceUpdate => _config.getBool('force_update');
  static String get customDownloadLink => _config.getString('download_link');
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
