import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class StaggeredGridViewWithNativeAds extends StatelessWidget {
  const StaggeredGridViewWithNativeAds({
    super.key,
    required this.gridItems,
    required this.nativeAds,
    required this.isAdLoaded,
  });

  final List<dynamic> gridItems;
  final Map<int, NativeAd> nativeAds;
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

            if (isAdLoaded[adIndex] == true && nativeAds[adIndex] != null) {
              return StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 2,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: AdWidget(ad: nativeAds[adIndex]!),
                ),
              );
            } else {
              return StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                child: Container(
                  alignment: Alignment.center,
                  color: Theme.of(context).cardColor,
                  width: double.infinity,
                  height: 150.0,
                  child: Text(
                    "Ad loading...",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
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
