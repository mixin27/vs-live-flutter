import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/features/live_match/presentation/live_match_list/live_match_providers.dart';
import 'package:vs_live/src/routing/app_router.dart';
import 'package:vs_live/src/utils/format.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/widgets/async_value_ui.dart';
import 'package:vs_live/src/widgets/glassmorphism/glassmorphism.dart';
import 'package:vs_live/src/widgets/text/animated_live_text.dart';
import 'package:vs_live/src/widgets/text/animated_text.dart';

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
        state.showAlertDialogOnError(context);

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
          Text(error.toString()),
        ]),
      _ => SliverList.list(
          children: [Text("No matches found".hardcoded)],
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
          header: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Text(
              match.league.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Image
                Expanded(
                  child: TeamInfoWidget(
                    team: match.homeTeam,
                    size: 50,
                  ),
                ),
                const SizedBox(width: Sizes.p12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "VS".hardcoded,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      if (match.liveStatus) ...[
                        const SizedBox(height: 4),
                        AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            AnimatedLiveText(
                              "LIVE",
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: Sizes.p12),
                Expanded(
                  child: TeamInfoWidget(
                    team: match.awayTeam,
                    size: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TeamInfoWidget extends StatelessWidget {
  const TeamInfoWidget({
    super.key,
    required this.team,
    this.size = 35,
    this.isShort = true,
  });

  final FootballTeam team;
  final double size;
  final bool isShort;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: team.logo,
            imageBuilder: (context, imageProvider) => Container(
              width: size,
              height: size,
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
          const SizedBox(height: 4),
          Text(
            isShort ? team.name.substring(0, 3) : team.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      match.league.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 12,
                          ),
                    ),
                  ),
                  const SizedBox(height: Sizes.p16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Image
                      Expanded(
                        child: TeamInfoWidget(
                          team: match.homeTeam,
                          size: 50,
                          isShort: false,
                        ),
                      ),
                      const SizedBox(width: Sizes.p12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "VS".hardcoded,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            if (match.liveStatus) ...[
                              const SizedBox(height: 4),
                              AnimatedTextKit(
                                repeatForever: true,
                                animatedTexts: [
                                  AnimatedLiveText(
                                    "LIVE",
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: Sizes.p12),
                      Expanded(
                        child: TeamInfoWidget(
                          team: match.awayTeam,
                          size: 50,
                          isShort: false,
                        ),
                      ),
                    ],
                  ),
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

// class GlassContainer extends StatefulWidget {
//   const GlassContainer(
//       {super.key, this.child, this.onTap, this.width, this.height});

//   final Widget? child;
//   final VoidCallback? onTap;
//   final double? width;
//   final double? height;

//   @override
//   State<GlassContainer> createState() => _GlassContainerState();
// }

// class _GlassContainerState extends State<GlassContainer> {
//   bool isPressed = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onTap,
//       onTapUp: (_) {
//         setState(() => isPressed = true);
//       },
//       onTapDown: (_) {
//         setState(() => isPressed = false);
//       },
//       child: Material(
//         elevation: 0,
//         shadowColor: Colors.black26,
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(20),
//         clipBehavior: Clip.antiAlias,
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             height: widget.width,
//             width: widget.height,
//             child: widget.child,
//           ),
//         ),
//       ),
//     );
//   }
// }
