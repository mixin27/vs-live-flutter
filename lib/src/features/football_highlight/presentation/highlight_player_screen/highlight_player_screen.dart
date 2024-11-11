import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vs_live/src/utils/extensions/dart_extensions.dart';
import 'package:vs_live/src/widgets/video_player/video_player_embed.dart';

class HighlightPlayerScreen extends StatefulWidget {
  const HighlightPlayerScreen({super.key, required this.embedVideo});

  final String embedVideo;

  @override
  State<HighlightPlayerScreen> createState() => _HighlightPlayerScreenState();
}

class _HighlightPlayerScreenState extends State<HighlightPlayerScreen> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  Widget build(BuildContext context) {
    final iframeInner = widget.embedVideo.getBetween("<iframe", "</iframe>");
    final iframe = "<iframe $iframeInner</iframe>";
    log(iframe);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(CupertinoIcons.back),
          ),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: VideoPlayerEmbed(
                  embedString: iframe,
                  keepAlive: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _resetOrientation();
    super.dispose();
  }

  void _resetOrientation() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}
