import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/football_highlight/domain/football_highlight.dart';
import 'package:vs_live/src/routing/app_router.dart';
import 'package:vs_live/src/utils/format.dart';
import 'package:vs_live/src/widgets/glassmorphism/glassmorphism.dart';

class HighlightGridView extends ConsumerStatefulWidget {
  const HighlightGridView({super.key, required this.highlights});

  final List<FootballHighlight> highlights;

  @override
  ConsumerState<HighlightGridView> createState() => _HighlightGridViewState();
}

class _HighlightGridViewState extends ConsumerState<HighlightGridView> {
  // final Map<int, NativeAd> _nativeAds = {}; // Map to hold NativeAd instances
  // final Set<int> _adIndices = {}; // Positions to insert ads
  // final Map<int, bool> _isAdLoaded = {}; // Tracks ad load states

  // final Map<int, BannerAd> _bannerAds = {};
  // final Map<int, bool> _isBannerAdLoaded = {};

  // @override
  // void initState() {
  //   super.initState();

  //   for (int i = 0; i < widget.highlights.length; i++) {
  //     if ((i + 1) % 5 == 0) {
  //       _adIndices.add(i + 1);
  //     }
  //   }

  //   // Load ads at specified positions
  //   for (int index in _adIndices) {
  //     // _loadNativeAd(index);
  //     _loadBannerAd(index);
  //   }
  // }

  // void _loadNativeAd(int index) {
  //   NativeAd nativeAd = NativeAd(
  //     adUnitId: AppRemoteConfig.nativeId,
  //     request: const AdRequest(),
  //     listener: NativeAdListener(
  //       onAdLoaded: (_) {
  //         setState(() {
  //           _isAdLoaded[index] = true;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, error) {
  //         ad.dispose();
  //         setState(() {
  //           _isAdLoaded[index] = false;
  //         });
  //         log('Native Ad failed to load at index $index: $error');
  //       },
  //     ),
  //     nativeTemplateStyle: NativeTemplateStyle(
  //       templateType: TemplateType.medium,
  //     ),
  //   );
  //   nativeAd.load();

  //   setState(() {
  //     _nativeAds[index] = nativeAd;
  //   });
  // }

  // void _loadBannerAd(int index) {
  //   final bannerAd = BannerAd(
  //     adUnitId: AppRemoteConfig.bannerId,
  //     request: const AdRequest(),
  //     size: AdSize.banner,
  //     listener: BannerAdListener(
  //       // Called when an ad is successfully received.
  //       onAdLoaded: (ad) {
  //         debugPrint('$ad loaded.');
  //         setState(() {
  //           _isBannerAdLoaded[index] = true;
  //         });
  //       },
  //       // Called when an ad request failed.
  //       onAdFailedToLoad: (ad, err) {
  //         debugPrint('BannerAd failed to load: $err');
  //         setState(() {
  //           _isBannerAdLoaded[index] = false;
  //         });
  //         // Dispose the ad here to free resources.
  //         ad.dispose();
  //       },
  //     ),
  //   )..load();

  //   setState(() {
  //     _bannerAds[index] = bannerAd;
  //   });
  // }

  @override
  void dispose() {
    // Dispose all ads
    // for (var ad in _nativeAds.values) {
    //   ad.dispose();
    // }
    // for (var ad in _bannerAds.values) {
    //   ad.dispose();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create a mixed list of items and ads
    // final List<dynamic> gridItems = [];
    // for (int i = 0; i < widget.highlights.length; i++) {
    //   gridItems.add(HighlightGridItem(highlight: widget.highlights[i]));

    //   if (_adIndices.contains(i)) {
    //     gridItems.add("ad-$i"); // Ad placeholder for position tracking
    //   }
    // }

    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final item = widget.highlights[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: HighlightGridItem(highlight: item),
        );
      },
    );

    // return SliverToBoxAdapter(
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 8),
    //     child: StaggeredGridViewWithBannerAds(
    //       gridItems: gridItems,
    //       bannerAds: _bannerAds,
    //       isAdLoaded: _isBannerAdLoaded,
    //     ),
    //   ),
    // );
  }
}

class HighlightGridItem extends ConsumerWidget {
  const HighlightGridItem({super.key, required this.highlight});

  final FootballHighlight highlight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        context.pushNamed(
          AppRoute.highlightPlayer.name,
          queryParameters: {
            "embedVideo": highlight.embed,
          },
        );
      },
      child: GlassmorphicContainer(
        borderRadius: 20,
        border: 0,
        blur: 20,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.secondary.withOpacity(0.3),
            Theme.of(context).colorScheme.secondary.withOpacity(0.08),
          ],
          stops: const [0.1, 1],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          ],
        ),
        child: GridTile(
          header: GridTileBar(
            // backgroundColor: Theme.of(context).cardColor,
            title: Text(
              highlight.competition.name,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          footer: GridTileBar(
            // backgroundColor: Theme.of(context).cardColor,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gapH8,
                Text(
                  highlight.title,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(
                  Format.format(DateTime.parse(highlight.date)),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: highlight.thumbnail,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            placeholder: (context, url) => const CupertinoActivityIndicator(),
            errorWidget: (context, url, error) =>
                const Icon(Icons.broken_image_outlined),
          ),
        ),
      ),
    );
  }
}
