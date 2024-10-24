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
    this.type = VideoType.normal,
  });

  final String videoUrl;
  final bool isLive;
  final VideoType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (type) {
      VideoType.iframe => Align(
          alignment: Alignment.center,
          child: VideoPlayerIframe(
            videoUrl: videoUrl,
            backgroundColor: Colors.black,
            keepAlive: true,
          ),
        ),
      VideoType.youtube => VideoPlayerYoutube(videoUrl: videoUrl),
      _ => VideoPlayerChewie(
          videoUrl: videoUrl,
          isLive: isLive,
        ),
    };
  }
}

enum VideoType { normal, iframe, youtube }

extension VideoTypeX on String {
  VideoType getVideoType() {
    return switch (this) {
      "iframe" => VideoType.iframe,
      "youtube" => VideoType.youtube,
      _ => VideoType.normal,
    };
  }
}
