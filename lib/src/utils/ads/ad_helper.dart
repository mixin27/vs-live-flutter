import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vs_live/src/utils/dialogs.dart';
import 'package:vs_live/src/utils/remote_config/remote_config.dart';

class AdHelper {
  // for initializing ads sdk
  static Future<void> initAds() async {
    await MobileAds.instance.initialize();
  }

  static InterstitialAd? _interstitialAd;
  static bool _interstitialAdLoaded = false;

  static NativeAd? _nativeAd;
  static bool _nativeAdLoaded = false;

  //*****************Interstitial Ad******************
  static void precacheInterstitialAd() {
    log('Precache Interstitial Ad - Id: ${AppRemoteConfig.interstitialId}');

    if (AppRemoteConfig.hideAds) return;

    final adUnitId = !kReleaseMode
        ? "ca-app-pub-3940256099942544/1033173712"
        : AppRemoteConfig.interstitialId;
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _resetInterstitialAd();
              precacheInterstitialAd();
            },
          );
          _interstitialAd = ad;
          _interstitialAdLoaded = true;
        },
        onAdFailedToLoad: (error) {
          _resetInterstitialAd();
          log('Failed to load an interstitial ad: ${error.message}');
        },
      ),
    );
  }

  static void _resetInterstitialAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _interstitialAdLoaded = false;
  }

  static void showInterstitialAd(
    BuildContext context, {
    required VoidCallback onComplete,
  }) {
    final adUnitId = !kReleaseMode
        ? "ca-app-pub-3940256099942544/1033173712"
        : AppRemoteConfig.interstitialId;
    log('Interstitial Ad Id: $adUnitId');

    if (AppRemoteConfig.hideAds) {
      onComplete();
      return;
    }

    if (_interstitialAdLoaded && _interstitialAd != null) {
      _interstitialAd?.show();
      onComplete();
      return;
    }

    showLoadingDialog(context);

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          //ad listener
          ad.fullScreenContentCallback =
              FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            onComplete();
            _resetInterstitialAd();
            precacheInterstitialAd();
          });
          Navigator.pop(context);
          ad.show();
        },
        onAdFailedToLoad: (err) {
          Navigator.pop(context);
          log('Failed to load an interstitial ad: ${err.message}');
          onComplete();
        },
      ),
    );
  }

  //*****************Native Ad******************
  static void precacheNativeAd() {
    final adUnitId = !kReleaseMode
        ? "ca-app-pub-3940256099942544/2247696110"
        : AppRemoteConfig.nativeId;
    log('Precache Native Ad - Id: $adUnitId');

    if (AppRemoteConfig.hideAds) return;

    _nativeAd = NativeAd(
      adUnitId: adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          log('$NativeAd loaded.');
          _nativeAdLoaded = true;
        },
        onAdFailedToLoad: (ad, error) {
          _resetNativeAd();
          log('$NativeAd failed to load: $error');
        },
      ),
      request: const AdRequest(),
      // Styling
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
      ),
    )..load();
  }

  static void _resetNativeAd() {
    _nativeAd?.dispose();
    _nativeAd = null;
    _nativeAdLoaded = false;
  }

  static NativeAd? loadNativeAd({VoidCallback? onLoaded}) {
    final adUnitId = !kReleaseMode
        ? "ca-app-pub-3940256099942544/2247696110"
        : AppRemoteConfig.nativeId;
    log('Native Ad Id: $adUnitId');

    if (AppRemoteConfig.hideAds) return null;

    if (_nativeAdLoaded && _nativeAd != null) {
      onLoaded?.call();
      return _nativeAd;
    }

    return NativeAd(
      adUnitId: adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          log('$NativeAd loaded.');
          onLoaded?.call();
          _resetNativeAd();
          precacheNativeAd();
        },
        onAdFailedToLoad: (ad, error) {
          _resetNativeAd();
          log('$NativeAd failed to load: $error');
        },
      ),
      request: const AdRequest(),
      // Styling
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
      ),
    )..load();
  }

  //*****************Rewarded Ad******************
  static void showRewardedAd(
    BuildContext context, {
    required VoidCallback onComplete,
  }) {
    final adUnitId = !kReleaseMode ? "" : AppRemoteConfig.rewardedId;
    log('Rewarded Ad Id: $adUnitId');

    if (AppRemoteConfig.hideAds) {
      onComplete();
      return;
    }

    showLoadingDialog(context);

    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          Navigator.pop(context);

          //reward listener
          ad.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
              onComplete();
            },
          );
        },
        onAdFailedToLoad: (err) {
          Navigator.pop(context);
          log('Failed to load an interstitial ad: ${err.message}');
          // onComplete();
        },
      ),
    );
  }
}
