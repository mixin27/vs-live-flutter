import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MasonryGridWithAds extends StatelessWidget {
  final List<dynamic> gridItems;
  final List<NativeAd?> nativeAds;
  final List<bool> isAdLoaded;

  const MasonryGridWithAds({
    super.key,
    required this.gridItems,
    required this.nativeAds,
    required this.isAdLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two columns for regular items
      ),
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
      itemCount: gridItems.length,
      itemBuilder: (context, index) {
        final item = gridItems[index];

        if (item is String && item.startsWith("ad-")) {
          // Ad placeholder logic
          int adIndex = int.parse(item.split("-")[1]);

          if (isAdLoaded[adIndex] && nativeAds[adIndex] != null) {
            return Container(
              padding: const EdgeInsets.all(8.0),
              child: AdWidget(ad: nativeAds[adIndex]!),
            );
          } else {
            return Container(
              alignment: Alignment.center,
              color: Theme.of(context).cardColor,
              height: 150.0,
              child: Text(
                "Ad loading...",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            );
          }
        } else {
          // Regular grid item
          return Container(
            alignment: Alignment.center,
            color: Colors.blue[100 * (index % 9)],
            child: Text(item),
          );
        }
      },
    );
  }
}
