import 'package:flutter/material.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/widgets/text/animated_live_text.dart';
import 'package:vs_live/src/widgets/text/animated_text.dart';

import 'team_info_widget.dart';

class MatchInfoWidget extends StatelessWidget {
  const MatchInfoWidget({
    super.key,
    required this.match,
    this.logoSize = 50,
  });

  final LiveMatch match;
  final double logoSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Image
        Expanded(
          child: TeamInfoWidget(
            team: match.homeTeam,
            size: logoSize,
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
                      textStyle:
                          Theme.of(context).textTheme.labelSmall?.copyWith(
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
            size: logoSize,
          ),
        ),
      ],
    );
  }
}
