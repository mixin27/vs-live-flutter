import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vs_live/src/utils/ads/ad_helper.dart';

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
    final ad = AdHelper.loadBannerAd(
      onLoaded: () {
        setState(() {
          _isLoaded = true;
        });
      },
    );

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
