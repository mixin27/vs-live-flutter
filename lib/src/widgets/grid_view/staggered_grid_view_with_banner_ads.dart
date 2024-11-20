import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class StaggeredGridViewWithBannerAds extends StatelessWidget {
  const StaggeredGridViewWithBannerAds({
    super.key,
    required this.gridItems,
    required this.bannerAds,
    required this.isAdLoaded,
  });

  final List<dynamic> gridItems;
  final Map<int, BannerAd> bannerAds;
  final Map<int, bool> isAdLoaded;

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: List.generate(
        gridItems.length,
        (index) {
          final item = gridItems[index];

          if (item is String && item.startsWith("ad-")) {
            int adIndex = int.parse(item.split("-")[1]);

            if (isAdLoaded[adIndex] == true && bannerAds[adIndex] != null) {
              return StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                // child: AdWidget(ad: nativeAds[adIndex]!),
                child: SizedBox(
                  width: double.infinity,
                  height: bannerAds[adIndex]!.size.height.toDouble(),
                  child: AdWidget(ad: bannerAds[adIndex]!),
                ),
              );
            } else {
              return StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: bannerAds[adIndex]!.size.height.toDouble(),
                    child: Center(
                      child: Text(
                        "Ad loading...",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  ),
                ),
              );
            }
          } else {
            return StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 1,
              child: gridItems[index],
            );
          }
        },
      ),
    );
  }
}
