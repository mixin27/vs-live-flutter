import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MasonryGridWithAdsScrollView extends StatelessWidget {
  final List<dynamic> gridItems; // Items and ad placeholders
  final List<NativeAd?> nativeAds;
  final List<bool> isAdLoaded;

  const MasonryGridWithAdsScrollView({
    super.key,
    required this.gridItems,
    required this.nativeAds,
    required this.isAdLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          expandedHeight: 150.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text("CustomScrollView Example"),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = gridItems[index];

                if (item is String && item.startsWith("ad-")) {
                  // Ad placeholder logic
                  int adIndex = int.parse(item.split("-")[1]);

                  if (isAdLoaded[adIndex] && nativeAds[adIndex] != null) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: AdWidget(ad: nativeAds[adIndex]!),
                    );
                  } else {
                    return Container(
                      height: 150.0,
                      alignment: Alignment.center,
                      color: Theme.of(context).cardColor,
                      child: Text(
                        "Ad loading...",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface),
                      ),
                    );
                  }
                } else {
                  // Regular grid item
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    alignment: Alignment.center,
                    height: index.isEven ? 200.0 : 150.0, // Variable height
                    color: Colors.blue[100 * (index % 9)],
                    child: Text(item),
                  );
                }
              },
              childCount: gridItems.length,
            ),
          ),
        ),
      ],
    );
  }
}
