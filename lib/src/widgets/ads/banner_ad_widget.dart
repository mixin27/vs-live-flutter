import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vs_live/src/utils/remote_config/remote_config.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  void loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    // final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
    //     MediaQuery.sizeOf(context).width.truncate());

    final ad = BannerAd(
      adUnitId: AppRemoteConfig.bannerId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();

    setState(() {
      _bannerAd = ad;
    });
  }

  @override
  Widget build(BuildContext context) {
    log("_isLoaded: $_isLoaded");
    return _bannerAd != null && _isLoaded
        ? SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          )
        : const SizedBox();
  }
}
