import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/features/live_match/presentation/widgets/league_info_widget.dart';
import 'package:vs_live/src/features/live_match/presentation/widgets/match_info_widget.dart';
import 'package:vs_live/src/routing/app_router.dart';
import 'package:vs_live/src/utils/ads/ad_helper.dart';
import 'package:vs_live/src/utils/format.dart';
import 'package:vs_live/src/widgets/glassmorphism/glassmorphism.dart';

class LiveMatchListView extends StatefulWidget {
  const LiveMatchListView({
    super.key,
    required this.matches,
  });

  final List<LiveMatch> matches;

  @override
  State<LiveMatchListView> createState() => _LiveMatchListViewState();
}

class _LiveMatchListViewState extends State<LiveMatchListView> {
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;

  @override
  void initState() {
    super.initState();

    loadBannerAd();
  }

  void loadBannerAd() async {
    final ad = AdHelper.loadBannerAd(
      onLoaded: () {
        setState(() {
          _isBannerLoaded = true;
        });
      },
    );
    setState(() {
      _bannerAd = ad;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [];

    for (int i = 0; i < widget.matches.length; i++) {
      // Add a regular item
      items.add(LiveMatchItem(match: widget.matches[i]));

      // Insert an ad after every 5th item
      if ((i + 1) % 5 == 0 && _bannerAd != null) {
        items.add(
          _bannerAd != null && _isBannerLoaded
              ? SafeArea(
                  child: SizedBox(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                )
              : const SizedBox(),
        );
      }
    }

    return SliverList.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return items[index];
      },
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}

class LiveMatchItem extends ConsumerWidget {
  const LiveMatchItem({
    super.key,
    required this.match,
  });

  final LiveMatch match;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: InkWell(
        onTap: () {
          context.pushNamed(AppRoute.liveMatchDetail.name, extra: match);
        },
        borderRadius: BorderRadius.circular(20),
        child: GlassmorphicContainer(
          borderRadius: 20,
          border: 2,
          blur: 20,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              Theme.of(context).colorScheme.secondary.withOpacity(0.03),
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
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LeagueInfoWidget(league: match.league),
                  const SizedBox(height: Sizes.p16),
                  MatchInfoWidget(match: match),
                ],
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
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
            ],
          ),
        ),
      ),
    );
  }
}
