import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/features/live_match/presentation/widgets/match_info_widget.dart';
import 'package:vs_live/src/routing/app_router.dart';
import 'package:vs_live/src/utils/format.dart';
import 'package:vs_live/src/widgets/video_player/adaptive_video_player.dart';

class LiveMatchDetailScreen extends ConsumerStatefulWidget {
  const LiveMatchDetailScreen({
    super.key,
    required this.match,
  });

  final LiveMatch match;

  @override
  ConsumerState<LiveMatchDetailScreen> createState() =>
      _LiveMatchDetailScreenState();
}

class _LiveMatchDetailScreenState extends ConsumerState<LiveMatchDetailScreen> {
  late Widget videoWidget;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final links = widget.match.links;
    final dateStr = Format.parseAndFormatMatchDateTime(
      widget.match.startedDate,
      widget.match.startedTime,
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
                  Text(
                    widget.match.league.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  const SizedBox(height: Sizes.p16),
                  MatchInfoWidget(
                    match: widget.match,
                    logoSize: 60,
                  ),
                  const SizedBox(height: Sizes.p16),
                  Text(
                    dateStr,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizes.p16,
                    vertical: Sizes.p4,
                  ),
                  child: Divider(),
                ),
              ],
            ),
          ),
          LiveLinkList(links: links),
        ],
      ),
    );
  }
}

class LiveLinkList extends StatelessWidget {
  const LiveLinkList({
    super.key,
    required this.links,
  });

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
  const LiveLinkItem({
    super.key,
    required this.link,
  });

  final LiveLink link;

  @override
  State<LiveLinkItem> createState() => _LiveLinkItemState();
}

class _LiveLinkItemState extends State<LiveLinkItem> {
  String _selected = '';

  @override
  Widget build(BuildContext context) {
    final isSelected = _selected == widget.link.url;

    return ListTile(
      onTap: () {
        setState(() {
          _selected = widget.link.url;
        });
        log({"videoUrl": widget.link.url}.toString());
        context.pushNamed(
          AppRoute.player.name,
          queryParameters: {
            "videoUrl": widget.link.url,
            "videoType": VideoType.normal.name,
          },
        );
      },
      leading: CircleAvatar(
        backgroundColor:
            isSelected ? Theme.of(context).colorScheme.secondary : null,
        foregroundColor:
            isSelected ? Theme.of(context).colorScheme.onSecondary : null,
        child: const Icon(Icons.sd_outlined),
      ),
      title: Text(widget.link.name),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      selected: _selected == widget.link.url,
      // selectedTileColor: Theme.of(context).colorScheme.primary,
      selectedColor: Theme.of(context).colorScheme.secondary,
      // tileColor: Theme.of(context).colorScheme.primaryFixed,
      // textColor: Theme.of(context).colorScheme.onPrimaryFixed,
    );
  }
}
