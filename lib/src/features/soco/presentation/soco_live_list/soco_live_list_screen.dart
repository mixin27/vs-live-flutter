import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/soco/presentation/soco_live_list/soco_live_list_provider.dart';
import 'package:vs_live/src/features/soco/presentation/soco_live_list/widgets/soco_live_list_view_widget.dart';
import 'package:vs_live/src/routing/app_router.dart';
import 'package:vs_live/src/utils/ads/ad_helper.dart';
import 'package:vs_live/src/utils/analytics_util.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/utils/remote_config/remote_config.dart';
import 'package:vs_live/src/widgets/theme/theme_mode_switch_button.dart';

class SocoLiveListScreen extends StatefulWidget {
  const SocoLiveListScreen({super.key});

  @override
  State<SocoLiveListScreen> createState() => _SocoLiveListScreenState();
}

class _SocoLiveListScreenState extends State<SocoLiveListScreen> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  NativeAd? _nativeAd;
  bool _isNativeAdLoaded = false;

  @override
  void initState() {
    // Record a visit to this page.
    AnalyticsUtil.logScreenView(screenName: 'SocoLiveListScreen');
    super.initState();

    if (!AppRemoteConfig.hideAdsInMatchList) {
      final pageAdsInfo = AppRemoteConfig.liveMatchListAdsInfo;

      if (pageAdsInfo.banner) {
        loadBannerAd();
      }

      if (pageAdsInfo.native) {
        loadNativeAd();
      }
    }
  }

  void loadBannerAd() {
    final ad = AdHelper.loadBannerAd(
      onLoaded: () {
        setState(() {
          _isAdLoaded = true;
        });
      },
    );
    setState(() {
      _bannerAd = ad;
    });
  }

  void loadNativeAd() {
    final ad = AdHelper.loadNativeAd(onLoaded: () {
      setState(() {
        _isNativeAdLoaded = true;
      });
    });
    setState(() {
      _nativeAd = ad;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            title: Text("Live Matches".hardcoded),
            floating: true,
            snap: true,
            pinned: true,
            actions: [
              const ThemeModeSwitchButton(),
              IconButton(
                onPressed: () {
                  context.goNamed(AppRoute.settings.name);
                },
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          ),
          Consumer(
            builder: (context, ref, child) {
              return CupertinoSliverRefreshControl(
                onRefresh: () => ref.refresh(getSocoLiveMatchesProvider.future),
              );
            },
          ),
          SliverList.list(children: [
            if (_bannerAd != null && _isAdLoaded)
              SizedBox(
                width: double.infinity,
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            const SizedBox(height: 20),
          ]),
          const SocoLiveListViewWidget(),
          if (_nativeAd != null && _isNativeAdLoaded)
            SliverList.list(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
                    child: SizedBox(
                      height: 400,
                      child: AdWidget(ad: _nativeAd!),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
