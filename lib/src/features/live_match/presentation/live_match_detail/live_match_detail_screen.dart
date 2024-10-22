import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/config/constants/app_sizes.dart';
import 'package:vs_live/src/features/live_match/domain/live_match.dart';
import 'package:vs_live/src/providers/video_link_provider.dart';
import 'package:vs_live/src/utils/extensions/flutter_extensions.dart';
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
  VideoType _videoType = VideoType.nomral;

  @override
  void initState() {
    super.initState();

    final links = widget.match.links;
    Future.microtask(
      () => ref.read(videoLinkStateProvider.notifier).setLink(links.first.url),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(videoLinkStateProvider, (prev, state) {
      if (prev == state) return;

      setState(() {
        if (state.contains("https://www.youtube.com")) {
          _videoType = VideoType.youtube;
        } else if (state.contains("src")) {
          _videoType = VideoType.iframe;
        } else {
          _videoType = VideoType.nomral;
        }
      });
    });

    final title =
        "${widget.match.homeTeam.name} - ${widget.match.awayTeam.name}";

    final links = widget.match.links;
    final videoLink = ref.watch(videoLinkStateProvider);
    log({videoLink}.toString());

    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(builder: (context, orientation) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: context.screenWidth,
                  height: context.screenWidth * 9.0 / 16.0 + 20,
                  child: AdaptiveVideoPlayer(
                    videoUrl: videoLink,
                    // videoUrl: "https://www.youtube.com/watch?v=XpBooWsGUn0",
                    isLive: true,
                    type: _videoType,
                  )),
              const SizedBox(height: Sizes.p16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _videoType = VideoType.nomral;
                        });
                      },
                      child: const Text("Normal"),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _videoType = VideoType.iframe;
                        });
                      },
                      child: const Text("Iframe"),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _videoType = VideoType.youtube;
                        });
                      },
                      child: const Text("YouTube Iframe"),
                    ),
                  ],
                ),
              ),
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
                        ref
                            .read(videoLinkStateProvider.notifier)
                            .setLink(link.url);
                      },
                      title: Text(link.name),
                      selected: videoLink == link.url,
                      selectedColor: Theme.of(context).colorScheme.secondary,
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
