import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/football_highlight/domain/football_highlight.dart';
import 'package:vs_live/src/features/football_highlight/presentation/feed/highlight_feed_providers.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/widgets/error_status_icon_widget.dart';

import 'highlight_grid_view.dart';
import 'highlight_list_view.dart';

enum ViewType { list, grid }

class FootballHighlightsList extends ConsumerStatefulWidget {
  const FootballHighlightsList({super.key, this.viewType = ViewType.grid});

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
    ref.listen(getAllHighlightsFeedProvider, (prev, state) {
      // state.showAlertDialogOnError(context);

      setState(() {
        _highlights = state.maybeWhen(
          orElse: () => prev?.value ?? [],
          data: (data) => data,
        );
      });
    });

    final state = ref.watch(getAllHighlightsFeedProvider);
    final searchState = ref.watch(searchHighlightsProvider);

    return switch (state) {
      AsyncData(:final value) when value.isNotEmpty =>
        widget.viewType == ViewType.grid
            ? HighlightGridView(
              highlights: searchState.isNotEmpty ? searchState : _highlights,
            )
            : HighlightListView(
              highlights: searchState.isNotEmpty ? searchState : _highlights,
            ),
      AsyncLoading() =>
        _highlights.isEmpty
            ? SliverList.list(children: const [CupertinoActivityIndicator()])
            : widget.viewType == ViewType.grid
            ? HighlightGridView(
              highlights: searchState.isNotEmpty ? searchState : _highlights,
            )
            : HighlightListView(
              highlights: searchState.isNotEmpty ? searchState : _highlights,
            ),
      AsyncError(:final error, stackTrace: var _) => SliverList.list(
        children: [
          Padding(
            padding: const EdgeInsets.all(Sizes.p16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ErrorStatusIconWidget(),
                const SizedBox(height: Sizes.p16),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: Sizes.p16),
                FilledButton(
                  onPressed:
                      () => ref.refresh(getAllHighlightsFeedProvider.future),
                  child: Text("Try again".hardcoded),
                ),
              ],
            ),
          ),
        ],
      ),
      _ => SliverList.list(
        children: [
          Padding(
            padding: const EdgeInsets.all(Sizes.p16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ErrorStatusIconWidget(icon: Icons.sports_soccer_outlined),
                const SizedBox(height: Sizes.p16),
                Text(
                  "No highlights available from the server".hardcoded,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: Sizes.p4),
                Text(
                  "Please come back later".hardcoded,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: Sizes.p16),
                FilledButton(
                  onPressed:
                      () => ref.refresh(getAllHighlightsFeedProvider.future),
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
