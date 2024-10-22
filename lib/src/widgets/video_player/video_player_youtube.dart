import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoPlayerYoutube extends StatefulWidget {
  const VideoPlayerYoutube({
    super.key,
    required this.videoUrl,
    this.aspectRatio = 16 / 9,
  });

  final String videoUrl;
  final double aspectRatio;

  @override
  State<VideoPlayerYoutube> createState() => _VideoPlayerYoutubeState();
}

class _VideoPlayerYoutubeState extends State<VideoPlayerYoutube> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final videoId = YoutubePlayerController.convertUrlToId(widget.videoUrl);

    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      params: const YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: true,
        autoPlay: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerIFrame(
      controller: _controller,
      aspectRatio: widget.aspectRatio,
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
