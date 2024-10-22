import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'video_player_chewie.dart';
import 'video_player_iframe.dart';
import 'video_player_youtube.dart';

class AdaptiveVideoPlayer extends ConsumerWidget {
  const AdaptiveVideoPlayer({
    super.key,
    required this.videoUrl,
    this.isLive = false,
    this.type = VideoType.nomral,
  });

  final String videoUrl;
  final bool isLive;
  final VideoType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (type) {
      VideoType.iframe => VideoPlayerIframe(
          videoUrl: videoUrl,
          backgroundColor: Colors.black,
          keepAlive: true,
          aspectRatio: 16 / 9,
        ),
        VideoType.youtube => VideoPlayerYoutube(videoUrl: videoUrl),
      _ => VideoPlayerChewie(
          videoUrl: videoUrl,
          isLive: isLive,
        ),
    };
  }
}

enum VideoType { nomral, iframe, youtube }
