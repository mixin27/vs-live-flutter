import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vs_live/src/utils/ads/ad_helper.dart';

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({super.key, this.height = 400});

  final double height;

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _isNativeAdLoaded = false;

  @override
  void initState() {
    super.initState();

    final nativeAd = AdHelper.loadNativeAd(
      onLoaded: () {
        setState(() {
          _isNativeAdLoaded = true;
        });
      },
    );

    setState(() {
      _nativeAd = nativeAd;
    });
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    _nativeAd = null;
    _isNativeAdLoaded = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isNativeAdLoaded && _nativeAd != null) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        width: double.infinity,
        alignment: Alignment.center,
        height: widget.height,
        child: AdWidget(ad: _nativeAd!),
      );
    }

    return Container(
      alignment: Alignment.center,
      height: 150.0,
      color: Colors.grey[300],
      child: const Text("Ad loading..."),
    );
  }
}
