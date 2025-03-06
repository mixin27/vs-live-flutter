import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:vs_live/src/utils/analytics_util.dart';
import 'package:vs_live/src/widgets/video_player/adaptive_video_player.dart';

class LiveMatchPlayerScreen extends StatefulWidget {
  const LiveMatchPlayerScreen({
    super.key,
    required this.videoUrl,
    this.videoType = VideoType.normal,
  });

  final String videoUrl;
  final VideoType videoType;

  @override
  State<LiveMatchPlayerScreen> createState() => _LiveMatchPlayerScreenState();
}

class _LiveMatchPlayerScreenState extends State<LiveMatchPlayerScreen> {
  @override
  void initState() {
    // Record a visit to this page.
    AnalyticsUtil.logScreenView(
      screenName: 'LiveMatchPlayerScreen',
    );

    super.initState();

    WakelockPlus.enable();

    // Force landscape mode
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    // Hide status and navigation bars for a true full-screen experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AdaptiveVideoPlayer(
        videoUrl: widget.videoUrl,
        isLive: true,
        type: widget.videoType,
      ),
    );
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _resetOrientation();
    super.dispose();
  }

  void _resetOrientation() {
    // Restore portrait mode when exiting the match screen
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    // Restore system UI settings
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}
