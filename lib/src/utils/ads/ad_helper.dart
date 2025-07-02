// ignore_for_file: unused_field

import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vs_live/src/utils/dialogs.dart';
import 'package:vs_live/src/utils/remote_config/remote_config.dart';

class AdHelper {
  // for initializing ads sdk
  static Future initAds() async {
    return MobileAds.instance.initialize();
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return !kReleaseMode
          ? 'ca-app-pub-3940256099942544/9214589741'
          : 'ca-app-pub-7567997114394639/8648546201';
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return !kReleaseMode
          ? 'ca-app-pub-3940256099942544/2247696110'
          : 'ca-app-pub-7567997114394639/9425876604';
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return !kReleaseMode
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-7567997114394639/1475405831';
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get appOpenAdUnitId {
    if (Platform.isAndroid) {
      return !kReleaseMode
          ? 'ca-app-pub-3940256099942544/9257395921'
          : 'ca-app-pub-7567997114394639/7748304172';
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return !kReleaseMode
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-7567997114394639/8288226195';
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static InterstitialAd? _interstitialAd;
  static bool _interstitialAdLoaded = false;

  static NativeAd? _nativeAd;
  static bool _nativeAdLoaded = false;

  static BannerAd? _bannerAd;
  static bool _bannerAdLoaded = false;

  //*****************Interstitial Ad******************
  static void precacheInterstitialAd() {
    if (AppRemoteConfig.hideAds) return;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
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
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          //ad listener
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              onComplete();
              _resetInterstitialAd();
              precacheInterstitialAd();
            },
          );
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
    if (AppRemoteConfig.hideAds || AppRemoteConfig.hideNativeAd) return;

    _nativeAd = NativeAd(
      adUnitId: nativeAdUnitId,
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
        templateType: TemplateType.medium,
      ),
    )..load();
  }

  static void _resetNativeAd() {
    _nativeAd?.dispose();
    _nativeAd = null;
    _nativeAdLoaded = false;
  }

  static NativeAd? loadNativeAd({VoidCallback? onLoaded}) {
    if (AppRemoteConfig.hideAds || AppRemoteConfig.hideNativeAd) return null;

    // if (_nativeAdLoaded && _nativeAd != null) {
    //   onLoaded?.call();
    //   return _nativeAd;
    // }

    return NativeAd(
      adUnitId: nativeAdUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          log('$NativeAd loaded.');
          onLoaded?.call();
          // _resetNativeAd();
          // precacheNativeAd();
        },
        onAdFailedToLoad: (ad, error) {
          // _resetNativeAd();
          log('$NativeAd failed to load: $error');
        },
      ),
      request: const AdRequest(),
      // Styling
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
      ),
    )..load();
  }

  // **************** Banner Ad*******************
  static void precacheBannerAd() {
    if (AppRemoteConfig.hideAds || AppRemoteConfig.hideBannerAd) return;

    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          log('$NativeAd loaded.');
          _bannerAdLoaded = true;
        },
        onAdFailedToLoad: (ad, error) {
          _resetBannerAd();
          log('$BannerAd failed to load: $error');
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  static void _resetBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _bannerAdLoaded = false;
  }

  static BannerAd? loadBannerAd({VoidCallback? onLoaded}) {
    if (AppRemoteConfig.hideAds || AppRemoteConfig.hideBannerAd) return null;

    // if (_bannerAdLoaded && _bannerAd != null) {
    //   onLoaded?.call();
    //   return _bannerAd;
    // }

    return BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          log('$BannerAd loaded.');
          onLoaded?.call();
          // _resetBannerAd();
          // precacheBannerAd();
        },
        onAdFailedToLoad: (ad, error) {
          // _resetBannerAd();
          log('$BannerAd failed to load: $error');
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  //*****************Rewarded Ad******************
  static void showRewardedAd(
    BuildContext context, {
    required VoidCallback onComplete,
  }) {
    if (AppRemoteConfig.hideAds || AppRemoteConfig.hideRewardedAd) {
      onComplete();
      return;
    }

    showLoadingDialog(context);

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
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

  // ****************** Consent ****************************
  static void showConsentUMP() {
    log("showConsentUMP called");
    if (AppRemoteConfig.hideAds) return;

    final params = ConsentRequestParameters();
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          loadForm();
        }
      },
      (FormError error) {
        // Handle the error
      },
    );
  }

  static void loadForm() {
    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        var status = await ConsentInformation.instance.getConsentStatus();
        if (status == ConsentStatus.required) {
          consentForm.show((FormError? formError) {
            loadForm();
          });
        }
      },
      (formError) {
        // Handle the error
      },
    );
  }
}
