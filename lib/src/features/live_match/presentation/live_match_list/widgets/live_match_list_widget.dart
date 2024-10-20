import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/features/live_match/presentation/live_match_detail/live_match_detail_screen.dart';
import 'package:vs_live/src/features/live_match/presentation/live_match_list/live_match_providers.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/widgets/async_value_ui.dart';

class LiveMatchListWidget extends ConsumerWidget {
  const LiveMatchListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      getAllLiveMatchProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    final state = ref.watch(getAllLiveMatchProvider);

    return switch (state) {
      AsyncData(value: var liveMatches) when liveMatches.isNotEmpty =>
        LiveMatchList(matches: liveMatches),
      AsyncLoading() => const Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(Sizes.p16),
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      AsyncError(:final error, stackTrace: var _) => Text(error.toString()),
      _ => Text("No matches found".hardcoded),
    };
  }
}

class LiveMatchList extends StatelessWidget {
  const LiveMatchList({
    super.key,
    required this.matches,
  });

  final List<LiveMatch> matches;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) => LiveMatchItem(match: matches[index]),
    );
  }
}

class LiveMatchItem extends StatelessWidget {
  const LiveMatchItem({
    super.key,
    required this.match,
  });

  final LiveMatch match;

  @override
  Widget build(BuildContext context) {
    final title = "${match.homeTeam.name} - ${match.awayTeam.name}";
    return ListTile(
      onTap: () {
        // context.goNamed(AppRoute.liveMatchDetail.name, extra: match);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LiveMatchDetailScreen(match: match),
          ),
        );
      },
      title: Text(title),
      subtitle: Text(match.startedDate),
      trailing: match.liveStatus
          ? Text(
              "LIVE".hardcoded,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: Sizes.p20,
                  fontWeight: FontWeight.bold),
            )
          : Text(match.startedTime),
    );
  }
}
