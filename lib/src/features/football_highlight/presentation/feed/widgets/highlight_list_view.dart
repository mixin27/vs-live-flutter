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

class HighlightListView extends ConsumerStatefulWidget {
  const HighlightListView({super.key, required this.highlights});

  final List<FootballHighlight> highlights;

  @override
  ConsumerState<HighlightListView> createState() => _HighlightListViewState();
}

class _HighlightListViewState extends ConsumerState<HighlightListView> {
  @override
  Widget build(BuildContext context) {
    // final List<Widget> items = [];

    // for (int i = 0; i < widget.highlights.length; i++) {
    //   // Add a regular item
    //   items.add(HighlightListItem(highlight: widget.highlights[i]));

    //   // Insert an ad after every 5th item
    //   if ((i + 1) % 5 == 0 && _bannerAd != null) {
    //     items.add(
    //       _bannerAd != null && _isLoaded
    //           ? SafeArea(
    //               child: SizedBox(
    //                 width: _bannerAd!.size.width.toDouble(),
    //                 height: _bannerAd!.size.height.toDouble(),
    //                 child: AdWidget(ad: _bannerAd!),
    //               ),
    //             )
    //           : const SizedBox(),
    //     );
    //   }
    // }

    return SliverList.builder(
      itemCount: widget.highlights.length,
      itemBuilder: (context, index) {
        return HighlightListItem(highlight: widget.highlights[index]);
      },
    );
  }
}

class HighlightListItem extends ConsumerWidget {
  const HighlightListItem({super.key, required this.highlight});

  final FootballHighlight highlight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p16,
        vertical: Sizes.p8,
      ),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            AppRoute.highlightPlayer.name,
            queryParameters: {
              "embedVideo": highlight.embed,
            },
          );
        },
        borderRadius: BorderRadius.circular(25),
        child: GlassmorphicContainer(
          borderRadius: 20,
          border: 0,
          blur: 20,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.08),
            ],
            stops: const [0.1, 1],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: highlight.thumbnail,
                imageBuilder: (context, imageProvider) => Container(
                  height: 180,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => const SizedBox(
                  height: 180,
                  child: Center(child: CupertinoActivityIndicator(radius: 30)),
                ),
                errorWidget: (context, url, error) => SizedBox(
                  height: 180,
                  child: Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 180,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.p16, vertical: Sizes.p8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      highlight.competition.name,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    gapH4,
                    Text(
                      highlight.title,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    gapH4,
                    Text(
                      Format.format(DateTime.parse(highlight.date)),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
