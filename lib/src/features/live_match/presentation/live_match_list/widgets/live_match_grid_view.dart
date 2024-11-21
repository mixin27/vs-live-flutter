import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/features/live_match/presentation/widgets/league_info_widget.dart';
import 'package:vs_live/src/features/live_match/presentation/widgets/match_info_widget.dart';
import 'package:vs_live/src/routing/app_router.dart';
import 'package:vs_live/src/utils/format.dart';
import 'package:vs_live/src/widgets/glassmorphism/glassmorphism.dart';

class LiveMatchGridView extends ConsumerStatefulWidget {
  const LiveMatchGridView({super.key, required this.matches});

  final List<LiveMatch> matches;

  @override
  ConsumerState<LiveMatchGridView> createState() => _LiveMatchGridViewState();
}

class _LiveMatchGridViewState extends ConsumerState<LiveMatchGridView> {
  // final Map<int, NativeAd> _nativeAds = {}; // Map to hold NativeAd instances
  // final Set<int> _adIndices = {}; // Positions to insert ads
  // final Map<int, bool> _isAdLoaded = {}; // Tracks ad load states

  @override
  void initState() {
    super.initState();

    // for (int i = 0; i < widget.matches.length; i++) {
    //   if ((i + 1) % 5 == 0) {
    //     _adIndices.add(i + 1);
    //   }
    // }

    // Load ads at specified positions
    // for (int index in _adIndices) {
    //   _loadNativeAd(index);
    // }
  }

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

  @override
  void dispose() {
    // Dispose all ads
    // for (var ad in _nativeAds.values) {
    //   ad.dispose();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create a mixed list of items and ads
    // final List<dynamic> gridItems = [];
    // for (int i = 0; i < widget.matches.length; i++) {
    //   gridItems.add(GridLiveMatchItem(match: widget.matches[i]));

    //   if (_adIndices.contains(i)) {
    //     gridItems.add("ad-$i"); // Ad placeholder for position tracking
    //   }
    // }

    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: widget.matches.length,
      itemBuilder: (context, index) {
        final item = widget.matches[index];

        return Padding(
          padding: EdgeInsets.only(
            left: index % 2 != 0 ? 0 : 16,
            right: index % 2 == 0 ? 0 : 16,
          ),
          child: GridLiveMatchItem(match: item),
        );
        // final item = gridItems[index];

        // if (item is String && item.startsWith("ad-")) {
        //   int adIndex = int.parse(item.split("-")[1]);

        //   if (_isAdLoaded[adIndex] == true && _nativeAds[adIndex] != null) {
        //     return Container(
        //       padding: const EdgeInsets.all(8.0),
        //       width: double.infinity,
        //       alignment: Alignment.center,
        //       height: 300.0,
        //       child: AdWidget(ad: _nativeAds[adIndex]!),
        //     );
        //   } else {
        //     return Container(
        //       alignment: Alignment.center,
        //       // height: 300.0,
        //       color: Theme.of(context).cardColor,
        //       child: Text(
        //         "Ad loading...",
        //         style: Theme.of(context)
        //             .textTheme
        //             .labelMedium
        //             ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
        //       ),
        //     );
        //   }
        // } else {
        //   return Padding(
        //     padding: EdgeInsets.only(
        //       left: index % 2 != 0 ? 0 : 16,
        //       right: index % 2 == 0 ? 0 : 16,
        //     ),
        //     child: GridLiveMatchItem(match: gridItems[index]),
        //   );
        // }
      },
    );
  }
}

class GridLiveMatchItem extends ConsumerWidget {
  const GridLiveMatchItem({super.key, required this.match});

  final LiveMatch match;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        context.pushNamed(AppRoute.liveMatchDetail.name, extra: match);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => LiveMatchDetailScreen(match: match),
        //   ),
        // );
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
          header: LeagueInfoWidget(league: match.league),
          footer: GridTileBar(
            title: Center(
              child: Text(
                match.startedTime,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ),
            subtitle: Center(
              child: Text(
                Format.matchDate(DateTime.parse(match.startedDate)),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: MatchInfoWidget(match: match),
          ),
        ),
      ),
    );
  }
}
