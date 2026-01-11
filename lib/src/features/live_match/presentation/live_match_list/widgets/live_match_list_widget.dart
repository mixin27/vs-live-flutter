import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/features/live_match/presentation/live_match_list/live_match_providers.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/widgets/error_status_icon_widget.dart';

import 'live_match_grid_view.dart';
import 'live_match_list_view.dart';

enum ViewType {
  list,
  grid,
}

class LiveMatchListWidget extends ConsumerStatefulWidget {
  const LiveMatchListWidget({
    super.key,
    this.viewType = ViewType.grid,
  });

  final ViewType viewType;

  @override
  ConsumerState<LiveMatchListWidget> createState() =>
      _LiveMatchListWidgetState();
}

class _LiveMatchListWidgetState extends ConsumerState<LiveMatchListWidget> {
  List<LiveMatch> _liveMatches = List.empty();

  @override
  Widget build(BuildContext context) {
    ref.listen(
      getAllLiveMatchProvider,
      (prev, state) {
        // state.showAlertDialogOnError(context);

        setState(() {
          _liveMatches = state.maybeWhen(
            orElse: () => prev?.value ?? [],
            data: (data) => data,
          );
        });
      },
    );

    final state = ref.watch(getAllLiveMatchProvider);
    final searchState = ref.watch(searchLiveMatchesProvider);

    return switch (state) {
      AsyncData(:final value) when value.isNotEmpty =>
        widget.viewType == ViewType.grid
            ? LiveMatchGridView(
                matches: searchState.isNotEmpty ? searchState : _liveMatches)
            : LiveMatchListView(
                matches: searchState.isNotEmpty ? searchState : _liveMatches),
      AsyncLoading() => _liveMatches.isEmpty
          ? SliverList.list(
              children: const [CupertinoActivityIndicator()],
            )
          : widget.viewType == ViewType.grid
              ? LiveMatchGridView(
                  matches: searchState.isNotEmpty ? searchState : _liveMatches,
                )
              : LiveMatchListView(
                  matches: searchState.isNotEmpty ? searchState : _liveMatches,
                ),
      AsyncError(:final error, stackTrace: var _) => SliverList.list(children: [
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
                  onPressed: () => ref.refresh(getAllLiveMatchProvider.future),
                  child: Text("Try again".hardcoded),
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
                  const ErrorStatusIconWidget(
                    icon: Icons.sports_soccer_outlined,
                  ),
                  const SizedBox(height: Sizes.p16),
                  Text(
                    "No matches available from the server".hardcoded,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: Sizes.p4),
                  Text(
                    "Please refresh again or come back later".hardcoded,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7)),
                  ),
                  const SizedBox(height: Sizes.p16),
                  FilledButton(
                    onPressed: () =>
                        ref.refresh(getAllLiveMatchProvider.future),
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
