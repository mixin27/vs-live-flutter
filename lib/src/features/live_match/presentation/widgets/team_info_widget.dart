import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';

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
    final hasShortName = team.shortName != null;
    final name = isShort && hasShortName ? team.shortName! : team.name;

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
            name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
