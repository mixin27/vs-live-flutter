// import 'package:flick_video_player/flick_video_player.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// import 'custom_video_portrait_controls.dart';

// class MyVideoPlayer extends StatefulWidget {
//   const MyVideoPlayer({
//     super.key,
//     required this.videoUrl,
//     this.isLive = false,
//   });

//   final String videoUrl;
//   final bool isLive;

//   @override
//   State<MyVideoPlayer> createState() => _MyVideoPlayerState();
// }

// class _MyVideoPlayerState extends State<MyVideoPlayer> {
//   late FlickManager _flickManager;

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideoPlayer();
//   }

//   Future<void> _initializeVideoPlayer() async {
//     final url = Uri.parse(widget.videoUrl);
//     // final url = Uri.parse(
//     //     "https://devstreaming-cdn.apple.com/videos/streaming/examples/adv_dv_atmos/main.m3u8");

//     _flickManager = FlickManager(
//       videoPlayerController: VideoPlayerController.networkUrl(url),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FlickVideoPlayer(
//       flickManager: _flickManager,
//       flickVideoWithControls: FlickVideoWithControls(
//         controls: CustomVideoPortraitControls(isLive: widget.isLive),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _flickManager.dispose();
//     super.dispose();
//   }
// }
