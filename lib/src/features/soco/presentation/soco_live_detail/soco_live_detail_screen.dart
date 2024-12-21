import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/soco/domain/soco_models.dart';
import 'package:vs_live/src/routing/app_router.dart';
import 'package:vs_live/src/utils/ads/ad_helper.dart';
import 'package:vs_live/src/utils/analytics_util.dart';
import 'package:vs_live/src/utils/format.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/utils/remote_config/remote_config.dart';
import 'package:vs_live/src/widgets/error_status_icon_widget.dart';
import 'package:vs_live/src/widgets/text/animated_live_text.dart';
import 'package:vs_live/src/widgets/text/animated_text.dart';
import 'package:vs_live/src/widgets/video_player/adaptive_video_player.dart';

class SocoLiveDetailScreen extends StatefulWidget {
  const SocoLiveDetailScreen({super.key, required this.match});

  final SocoLiveMatch match;

  @override
  State<SocoLiveDetailScreen> createState() => _SocoLiveDetailScreenState();
}

class _SocoLiveDetailScreenState extends State<SocoLiveDetailScreen> {
  NativeAd? _nativeAd;
  bool _isNativeAdLoaded = false;

  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    // Record a visit to this page.
    AnalyticsUtil.logScreenView(
      screenName: 'SocoLiveDetailScreen',
    );
    super.initState();

    if (!AppRemoteConfig.hideAdsInMatchDetail) {
      final pageAdsInfo = AppRemoteConfig.liveMatchDetailAdsInfo;
      if (pageAdsInfo.native) {
        loadNativeAd();
      }

      if (pageAdsInfo.banner) {
        loadBannerAd();
      }
    }
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

  void loadBannerAd() {
    final ad = AdHelper.loadBannerAd(onLoaded: () {
      setState(() {
        _isBannerAdLoaded = true;
      });
    });

    setState(() {
      _bannerAd = ad;
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emptyWidget = SliverList.list(
      children: [
        Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ErrorStatusIconWidget(
                icon: Icons.sports_soccer_outlined,
              ),
              const SizedBox(height: Sizes.p16),
              Text(
                "No available links found".hardcoded,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: Sizes.p4),
              Text(
                "May be the match has not been started yet".hardcoded,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7)),
              ),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            floating: true,
            snap: false,
            pinned: true,
            bottom: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 200,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.match.leaguename,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  const SizedBox(height: Sizes.p16),
                  SocoLiveMatchInfoWidget(match: widget.match),
                  const SizedBox(height: Sizes.p16),
                  Text(
                    Format.format(
                      Format.parseSocoMatchTime(widget.match.matchTime),
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Sizes.p16,
                vertical: Sizes.p16,
              ),
              child: Divider(),
            ),
          ),
          if (_bannerAd != null && _isBannerAdLoaded)
            SliverToBoxAdapter(
              child: SizedBox(
                width: double.infinity,
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
          if (widget.match.servers.isNotEmpty)
            LiveLinkList(links: widget.match.servers),
          if (widget.match.servers.isEmpty) emptyWidget,
          if (_nativeAd != null && _isNativeAdLoaded)
            SliverList.list(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.p16,
                    vertical: Sizes.p16,
                  ),
                  child: SizedBox(
                    height: 400,
                    child: AdWidget(ad: _nativeAd!),
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }
}

class LiveLinkList extends StatelessWidget {
  const LiveLinkList({
    super.key,
    required this.links,
  });

  final List<SocoLiveServer> links;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: links.length,
      itemBuilder: (context, index) {
        final link = links[index];
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p8,
            vertical: Sizes.p4,
          ),
          child: SocoLiveLinkItem(link: link),
        );
      },
    );
  }
}

class SocoLiveLinkItem extends StatelessWidget {
  const SocoLiveLinkItem({
    super.key,
    required this.link,
  });

  final SocoLiveServer link;

  @override
  Widget build(BuildContext context) {
    final resolutionIcon = link.name.toLowerCase().contains('hd')
        ? Icons.hd_outlined
        : Icons.sd_outlined;

    return ListTile(
      onTap: () {
        context.pushNamed(
          AppRoute.player.name,
          queryParameters: {
            "videoUrl": link.streamUrl,
            "videoType": VideoType.normal.name,
          },
        );
      },
      leading: CircleAvatar(
        child: Icon(resolutionIcon),
      ),
      title: Text(link.name),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class SocoLiveMatchInfoWidget extends StatelessWidget {
  const SocoLiveMatchInfoWidget({super.key, required this.match});

  final SocoLiveMatch match;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Image
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: match.homeTeamLogo,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const CupertinoActivityIndicator(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image_outlined),
                ),
                const SizedBox(height: 4),
                Text(
                  match.homeTeamName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: Sizes.p12),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (match.matchStatus.toLowerCase() != 'live')
                Text(
                  match.matchStatus.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              if (match.matchStatus.toLowerCase() == 'live') ...[
                const SizedBox(height: 4),
                AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    AnimatedLiveText(
                      "LIVE",
                      textStyle:
                          Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: Sizes.p12),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: match.awayTeamLogo,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const CupertinoActivityIndicator(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image_outlined),
                ),
                const SizedBox(height: 4),
                Text(
                  match.awayTeamName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
