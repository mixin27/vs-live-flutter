import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/features/live_match/presentation/live_match_list/live_match_providers.dart';
import 'package:vs_live/src/features/live_match/presentation/widgets/league_info_widget.dart';
import 'package:vs_live/src/features/live_match/presentation/widgets/match_info_widget.dart';
import 'package:vs_live/src/routing/app_router.dart';
import 'package:vs_live/src/utils/format.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/widgets/error_status_icon_widget.dart';
import 'package:vs_live/src/widgets/glassmorphism/glassmorphism.dart';

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
            orElse: () => prev?.valueOrNull ?? [],
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
                            .withOpacity(0.7)),
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

class LiveMatchGridView extends ConsumerWidget {
  const LiveMatchGridView({super.key, required this.matches});

  final List<LiveMatch> matches;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];

        return Padding(
          padding: EdgeInsets.only(
            left: index % 2 != 0 ? 0 : 16,
            right: index % 2 == 0 ? 0 : 16,
          ),
          child: GridLiveMatchItem(match: match),
        );
      },
    );
  }
}

class LiveMatchListView extends ConsumerWidget {
  const LiveMatchListView({
    super.key,
    required this.matches,
  });

  final List<LiveMatch> matches;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverList.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) => LiveMatchItem(match: matches[index]),
    );
  }
}

class GridLiveMatchItem extends ConsumerWidget {
  const GridLiveMatchItem({super.key, required this.match});

  final LiveMatch match;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        context.pushNamed(AppRoute.liveMatchDetail.name, extra: match);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => LiveMatchDetailScreen(match: match),
        //   ),
        // );
      },
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
          header: LeagueInfoWidget(league: match.league),
          footer: GridTileBar(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: MatchInfoWidget(match: match),
          ),
        ),
      ),
    );
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
