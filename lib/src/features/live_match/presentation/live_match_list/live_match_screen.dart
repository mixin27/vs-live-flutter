import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/features/live_match/presentation/live_match_list/live_match_providers.dart';
import 'package:vs_live/src/routing/app_router.dart';
import 'package:vs_live/src/utils/ads/ad_helper.dart';
import 'package:vs_live/src/utils/analytics_util.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/utils/onesignal/onesignal.dart';
import 'package:vs_live/src/utils/remote_config/remote_config.dart';
import 'package:vs_live/src/utils/scheduler.dart';
import 'package:vs_live/src/widgets/theme/theme_mode_switch_button.dart';
import 'package:wiredash/wiredash.dart';

import 'widgets/live_match_list_widget.dart';

class LiveMatchScreen extends StatefulWidget {
  const LiveMatchScreen({super.key});

  @override
  State<LiveMatchScreen> createState() => _LiveMatchScreenState();
}

class _LiveMatchScreenState extends State<LiveMatchScreen> {
  int _selectedView = 0;

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  NativeAd? _nativeAd;
  bool _isNativeAdLoaded = false;

  @override
  void initState() {
    // Record a visit to this page.
    AnalyticsUtil.logScreenView(screenName: 'LiveMatchScreen');
    super.initState();

    initOnesignal();
    initDeepLinks();

    if (!AppRemoteConfig.hideAdsInMatchList) {
      final pageAdsInfo = AppRemoteConfig.liveMatchListAdsInfo;

      if (pageAdsInfo.banner) {
        loadBannerAd();
      }

      if (pageAdsInfo.native) {
        loadNativeAd();
      }
    }

    AppScheduler.taskDaily('vpn_notice', () {
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          forceActionsBelow: true,
          padding: const EdgeInsets.all(20),
          leading: const Icon(Icons.warning_amber_rounded),
          content: const Text(
            'If you are from some restricted regions like Europe and America, you must use VPN to watch some stream links.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: const Text('DISMISS'),
            ),
          ],
        ),
      );
    });
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

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    try {
      // Handle links
      _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
        debugPrint('onAppLink: $uri');
        openAppLink(uri);
      });
    } catch (e) {
      log('[initDeepLinks] Error: ${e.toString()}');
    }
  }

  void openAppLink(Uri uri) {
    if (uri.scheme == 'bsl') {
      if (uri.host == 'open.bsl.app') {
        log('Handle bsl://open.bsl.app');
        // Navigate to a specific page
      } else if (uri.host == 'kyawzayartun.com') {
        log('Handle bsl://kyawzayartun.com');
        // Navigate to another page
      }
    } else if (uri.scheme == 'https' && uri.host == 'kyawzayartun.com') {
      if (uri.path == '/bsl') {
        log('Handle https://kyawzayartun.com/bsl');
        // Navigate to another page
      }
    } else if (uri.scheme == 'https' && uri.host == 'www.kyawzayartun.com') {
      if (uri.path == '/bsl') {
        log('Handle https://www.kyawzayartun.com/bsl');
        // Navigate to another page
      }
    }

    if (uri.queryParameters.containsKey('id')) {
      String appId = uri.queryParameters['id']!;
      log('App ID: $appId');
    }

    context.goNamed(AppRoute.home.name);
  }

  @override
  Widget build(BuildContext context) {
    final isGridView = _selectedView == 0;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Wiredash.of(context).show(inheritMaterialTheme: true);
        },
        child: const Icon(Icons.feedback_outlined),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            title: Text("Billion Sport Live".hardcoded),
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
              // IconButton(
              //   onPressed: () {
              //     // context.pushNamed(AppRoute.adsTest.name);
              //     showAdaptiveDialog(
              //       context: context,
              //       barrierDismissible: false,
              //       builder: (context) {
              //         return WatchAdDialog(
              //           onComplete: () {
              //             AdHelper.showInterstitialAd(
              //               context,
              //               onComplete: () {
              //                 ScaffoldMessenger.of(context).showSnackBar(
              //                   const SnackBar(
              //                     content: Text("Yayy! You are rewarded!!!"),
              //                   ),
              //                 );
              //               },
              //             );
              //           },
              //         );
              //       },
              //     );
              //   },
              //   icon: const Icon(Icons.ad_units_sharp),
              // ),
            ],
            bottom: AppBar(
              title: Row(
                children: [
                  const Expanded(
                    child: CustomSearchField(),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: Sizes.p8),
                    child: ToggleButtons(
                      constraints: const BoxConstraints(
                        minWidth: 30.0,
                        minHeight: 30.0,
                      ),
                      isSelected: [_selectedView == 0, _selectedView == 1],
                      onPressed: (index) {
                        if (index > 1) return;
                        setState(() {
                          _selectedView = index;
                        });
                      },
                      children: [
                        Tooltip(
                          message: "Grid".hardcoded,
                          child: const Icon(
                            Icons.grid_view_outlined,
                            size: 20,
                          ),
                        ),
                        Tooltip(
                          message: "List".hardcoded,
                          child: const Icon(Icons.list_outlined, size: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              return CupertinoSliverRefreshControl(
                onRefresh: () => ref.refresh(getAllLiveMatchProvider.future),
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
          LiveMatchListWidget(
            viewType: isGridView ? ViewType.grid : ViewType.list,
          ),
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

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _bannerAd?.dispose();
    _nativeAd?.dispose();
    super.dispose();
  }
}

class CustomSearchField extends ConsumerStatefulWidget {
  const CustomSearchField({
    super.key,
  });

  @override
  ConsumerState<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends ConsumerState<CustomSearchField> {
  final _searchController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(getAllLiveMatchProvider);
    final List<LiveMatch> data =
        state.maybeWhen(orElse: () => [], data: (data) => data);

    return CupertinoSearchTextField(
      controller: _searchController,
      placeholder: "Search".hardcoded,
      style: Theme.of(context).textTheme.labelLarge,
      onChanged: (value) {
        ref.read(searchLiveMatchesProvider.notifier).onSearch(value, data);
      },
      onSuffixTap: () {
        _searchController.clear();
        ref.read(searchLiveMatchesProvider.notifier).clear();
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
