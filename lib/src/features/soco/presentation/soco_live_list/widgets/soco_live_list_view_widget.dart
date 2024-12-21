import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/features/live_match/presentation/widgets/league_info_widget.dart';
import 'package:vs_live/src/features/soco/domain/soco_models.dart';
import 'package:vs_live/src/features/soco/presentation/soco_live_list/soco_live_list_provider.dart';
import 'package:vs_live/src/routing/app_router.dart';
import 'package:vs_live/src/utils/format.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/widgets/error_status_icon_widget.dart';
import 'package:vs_live/src/widgets/glassmorphism/glassmorphism.dart';
import 'package:vs_live/src/widgets/text/animated_live_text.dart';
import 'package:vs_live/src/widgets/text/animated_text.dart';

class SocoLiveListViewWidget extends ConsumerWidget {
  const SocoLiveListViewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(getSocoLiveMatchesProvider);

    return switch (state) {
      AsyncData(:final value) when value.isNotEmpty =>
        SocoLiveListView(matches: value),
      AsyncLoading() => SliverList.list(
          children: const [CupertinoActivityIndicator()],
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
                  onPressed: () =>
                      ref.refresh(getSocoLiveMatchesProvider.future),
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
                        ref.refresh(getSocoLiveMatchesProvider.future),
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

class SocoLiveListView extends StatelessWidget {
  const SocoLiveListView({super.key, required this.matches});

  final List<SocoLiveMatch> matches;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemBuilder: (context, index) {
        final match = matches[index];
        return SocoLiveListItem(match: match);
      },
    );
  }
}

class SocoLiveListItem extends StatelessWidget {
  const SocoLiveListItem({
    super.key,
    required this.match,
  });

  final SocoLiveMatch match;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.p8),
      child: InkWell(
        onTap: () {
          context.pushNamed(AppRoute.socoLivessDetails.name, extra: match);
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
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
              Theme.of(context).colorScheme.secondary.withValues(alpha: 0.03),
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
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LeagueInfoWidget(
                    league: FootballLeague(
                      id: match.hashCode,
                      name: match.leaguename,
                      logo: '',
                    ),
                  ),
                  const SizedBox(height: Sizes.p16),
                  Row(
                    children: [
                      // home team info
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: match.homeTeamLogo,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const CupertinoActivityIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.broken_image_outlined),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                match.homeTeamName,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (match.matchStatus.toLowerCase() != 'live')
                              Text(
                                match.matchStatus.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            if (match.matchStatus.toLowerCase() == 'live') ...[
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
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
                      // away team info
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: match.awayTeamLogo,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const CupertinoActivityIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.broken_image_outlined),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                match.awayTeamName,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
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
                    Format.format(Format.parseSocoMatchTime(match.matchTime)),
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
