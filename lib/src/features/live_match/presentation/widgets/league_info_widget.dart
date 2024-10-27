import 'package:flutter/material.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';

class LeagueInfoWidget extends StatelessWidget {
  const LeagueInfoWidget({
    super.key,
    required this.league,
  });

  final FootballLeague league;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Text(
        league.name,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
