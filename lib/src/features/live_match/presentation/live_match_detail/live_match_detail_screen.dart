import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/routing/app_router.dart';
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
    final title =
        "${widget.match.homeTeam.name} - ${widget.match.awayTeam.name}";
    final links = widget.match.links;

    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(builder: (context, orientation) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Sizes.p20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Image
                    CachedNetworkImage(
                      imageUrl: widget.match.homeTeam.logo,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image_outlined),
                    ),
                    const SizedBox(width: Sizes.p12),
                    Expanded(
                      child: Text(
                        "0 - 0",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 36,
                            ),
                      ),
                    ),
                    const SizedBox(width: Sizes.p12),
                    CachedNetworkImage(
                      imageUrl: widget.match.awayTeam.logo,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image_outlined),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Sizes.p20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: Sizes.p20),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: links.length,
                  itemBuilder: (context, index) {
                    final link = links[index];
                    return ListTile(
                      onTap: () {
                        log({"videoUrl": link.url}.toString());
                        context.pushNamed(
                          AppRoute.player.name,
                          queryParameters: {
                            "videoUrl": link.url,
                            "videoType": VideoType.normal.name,
                          },
                        );
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => LiveMatchPlayerScreen(
                        //       videoUrl: link.url,
                        //       videoType: VideoType.normal,
                        //     ),
                        //   ),
                        // );
                      },
                      title: Text(link.name),
                      // selected: videoLink == link.url,
                      // selectedColor: Theme.of(context).colorScheme.secondary,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: Sizes.p16),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
