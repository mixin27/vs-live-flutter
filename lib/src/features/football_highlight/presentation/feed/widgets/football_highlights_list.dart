import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/football_highlight/domain/football_highlight.dart';
import 'package:vs_live/src/features/football_highlight/presentation/feed/highlight_feed_providers.dart';
import 'package:vs_live/src/utils/format.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/widgets/glassmorphism/glassmorphism.dart';

enum ViewType {
  list,
  grid,
}

class FootballHighlightsList extends ConsumerStatefulWidget {
  const FootballHighlightsList({
    super.key,
    this.viewType = ViewType.grid,
  });

  final ViewType viewType;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FootballHighlightsListState();
}

class _FootballHighlightsListState
    extends ConsumerState<FootballHighlightsList> {
  List<FootballHighlight> _highlights = List.empty();

  @override
  Widget build(BuildContext context) {
    ref.listen(
      getAllHighlightsFeedProvider,
      (prev, state) {
        // state.showAlertDialogOnError(context);

        setState(() {
          _highlights = state.maybeWhen(
            orElse: () => prev?.valueOrNull ?? [],
            data: (data) => data,
          );
        });
      },
    );

    final state = ref.watch(getAllHighlightsFeedProvider);
    final searchState = ref.watch(searchHighlightsProvider);

    return switch (state) {
      AsyncData(:final value) when value.isNotEmpty =>
        widget.viewType == ViewType.grid
            ? HighlightGridView(
                highlights: searchState.isNotEmpty ? searchState : _highlights)
            : HighlightListView(
                highlights: searchState.isNotEmpty ? searchState : _highlights),
      AsyncLoading() => _highlights.isEmpty
          ? SliverList.list(
              children: const [CupertinoActivityIndicator()],
            )
          : widget.viewType == ViewType.grid
              ? HighlightGridView(
                  highlights:
                      searchState.isNotEmpty ? searchState : _highlights,
                )
              : HighlightListView(
                  highlights:
                      searchState.isNotEmpty ? searchState : _highlights,
                ),
      AsyncError(:final error, stackTrace: var _) => SliverList.list(children: [
          Padding(
            padding: const EdgeInsets.all(Sizes.p16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off_outlined,
                  size: 45,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                ),
                const SizedBox(height: Sizes.p16),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: Sizes.p16),
                TextButton(
                  onPressed: () =>
                      ref.refresh(getAllHighlightsFeedProvider.future),
                  child: Text("Retry".hardcoded),
                ),
              ],
            ),
          ),
        ]),
      _ => SliverList.list(
          children: [
            Padding(
              padding: const EdgeInsets.all(Sizes.p16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sports_soccer_outlined,
                    size: 45,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.8),
                  ),
                  const SizedBox(height: Sizes.p16),
                  Text(
                    "Currently, no highlights available from the server. Please come back later."
                        .hardcoded,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: Sizes.p16),
                  TextButton(
                    onPressed: () =>
                        ref.refresh(getAllHighlightsFeedProvider.future),
                    child: Text("Refresh".hardcoded),
                  ),
                ],
              ),
            ),
          ],
        ),
    };
  }
}

class HighlightGridView extends ConsumerWidget {
  const HighlightGridView({super.key, required this.highlights});

  final List<FootballHighlight> highlights;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: highlights.length,
      itemBuilder: (context, index) {
        final highlight = highlights[index];

        return Padding(
          padding: EdgeInsets.only(
            left: index % 2 != 0 ? 0 : 16,
            right: index % 2 == 0 ? 0 : 16,
          ),
          child: HighlightGridItem(highlight: highlight),
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
      onTap: () {},
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
              '${highlight.title}(${highlight.competition.name})',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          footer: GridTileBar(
            // backgroundColor: Theme.of(context).cardColor,
            title: Text(
              Format.format(DateTime.parse(highlight.date)),
              style: Theme.of(context).textTheme.labelMedium,
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

class HighlightListView extends ConsumerWidget {
  const HighlightListView({super.key, required this.highlights});

  final List<FootballHighlight> highlights;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverList.builder(
      itemCount: highlights.length,
      itemBuilder: (context, index) => HighlightListItem(
        highlight: highlights[index],
      ),
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
        onTap: () {},
        borderRadius: BorderRadius.circular(25),
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
                placeholder: (context, url) =>
                    const CupertinoActivityIndicator(),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image_outlined),
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
                          ),
                    ),
                    gapH4,
                    Text(
                      highlight.title,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    gapH4,
                    Text(
                      Format.format(DateTime.parse(highlight.date)),
                      style: Theme.of(context).textTheme.labelMedium,
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
