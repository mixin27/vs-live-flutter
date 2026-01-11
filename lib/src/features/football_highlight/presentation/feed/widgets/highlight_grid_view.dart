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
  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: widget.highlights.length,
      itemBuilder: (context, index) {
        final item = widget.highlights[index];
        return Padding(
          padding: EdgeInsets.only(
            left: index % 2 != 0 ? 0 : 16,
            right: index % 2 == 0 ? 0 : 16,
          ),
          child: HighlightGridItem(highlight: item),
        );
      },
    );
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
          queryParameters: {"embedVideo": highlight.embed},
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
        child: GridTile(
          header: GridTileBar(
            // backgroundColor: Theme.of(context).cardColor,
            title: Text(
              highlight.competition.name,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
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
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: highlight.thumbnail,
            imageBuilder:
                (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            placeholder: (context, url) => const CupertinoActivityIndicator(),
            errorWidget:
                (context, url, error) =>
                    const Icon(Icons.broken_image_outlined),
          ),
        ),
      ),
    );
  }
}
