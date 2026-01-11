import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/features/live_match/presentation/widgets/match_info_widget.dart';
import 'package:vs_live/src/routing/app_router.dart';
import 'package:vs_live/src/utils/analytics_util.dart';
import 'package:vs_live/src/utils/format.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';
import 'package:vs_live/src/widgets/error_status_icon_widget.dart';
import 'package:vs_live/src/widgets/video_player/adaptive_video_player.dart';

class LiveMatchDetailScreen extends ConsumerStatefulWidget {
  const LiveMatchDetailScreen({super.key, required this.match});

  final LiveMatch match;

  @override
  ConsumerState<LiveMatchDetailScreen> createState() =>
      _LiveMatchDetailScreenState();
}

class _LiveMatchDetailScreenState extends ConsumerState<LiveMatchDetailScreen> {
  late Widget videoWidget;

  @override
  void initState() {
    // Record a visit to this page.
    AnalyticsUtil.logScreenView(screenName: 'LiveMatchDetailScreen');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final links = widget.match.links;
    final dateStr = Format.parseAndFormatMatchDateTime(
      widget.match.startedDate,
      widget.match.startedTime,
    );

    final emptyWidget = SliverList.list(
      children: [
        Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ErrorStatusIconWidget(icon: Icons.sports_soccer_outlined),
              const SizedBox(height: Sizes.p16),
              Text(
                "No available links found".hardcoded,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: Sizes.p4),
              Text(
                "May be the match has not been started yet".hardcoded,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            floating: true,
            snap: false,
            pinned: true,
            bottom: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 150,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.match.league.logo,
                        imageBuilder:
                            (context, imageProvider) => Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                        placeholder:
                            (context, url) =>
                                const CupertinoActivityIndicator(),
                        errorWidget:
                            (context, url, error) =>
                                const Icon(Icons.broken_image_outlined),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.match.league.name,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Sizes.p16),
                  MatchInfoWidget(match: widget.match, logoSize: 60),
                  const SizedBox(height: Sizes.p16),
                  Text(
                    dateStr,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Sizes.p16,
                vertical: Sizes.p16,
              ),
              child: Divider(),
            ),
          ),

          if (links.isNotEmpty) LiveLinkList(links: links),
          if (links.isEmpty) emptyWidget,
        ],
      ),
    );
  }
}

class LiveLinkList extends StatelessWidget {
  const LiveLinkList({super.key, required this.links});

  final List<LiveLink> links;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: links.length,
      itemBuilder: (context, index) {
        final link = links[index];
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p8,
            vertical: Sizes.p4,
          ),
          child: LiveLinkItem(link: link),
        );
      },
    );
  }
}

class LiveLinkItem extends StatefulWidget {
  const LiveLinkItem({super.key, required this.link});

  final LiveLink link;

  @override
  State<LiveLinkItem> createState() => _LiveLinkItemState();
}

class _LiveLinkItemState extends State<LiveLinkItem> {
  String _selected = '';

  @override
  Widget build(BuildContext context) {
    final isSelected = _selected == widget.link.url;
    final videoType =
        widget.link.type?.name.getVideoType().name ?? VideoType.normal.name;

    final resolutionIcon = switch (widget.link.resolution
        .trim()
        .toLowerCase()) {
      "fhd" => Icons.hd,
      "hd" => Icons.hd_outlined,
      "sd" => Icons.sd_outlined,
      _ => Icons.link_outlined,
    };

    return ListTile(
      onTap: () {
        setState(() {
          _selected = widget.link.url;
        });
        context.pushNamed(
          AppRoute.player.name,
          queryParameters: {
            "videoUrl": widget.link.url,
            "videoType": videoType,
          },
        );
      },
      leading: CircleAvatar(
        backgroundColor:
            isSelected ? Theme.of(context).colorScheme.secondary : null,
        foregroundColor:
            isSelected ? Theme.of(context).colorScheme.onSecondary : null,
        child: Icon(resolutionIcon),
      ),
      title: Text(widget.link.name),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      selected: _selected == widget.link.url,
      // selectedTileColor: Theme.of(context).colorScheme.primary,
      selectedColor: Theme.of(context).colorScheme.secondary,
      // tileColor: Theme.of(context).colorScheme.primaryFixed,
      // textColor: Theme.of(context).colorScheme.onPrimaryFixed,
    );
  }
}
