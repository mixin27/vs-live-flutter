import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:vs_live/src/utils/extensions/flutter_extensions.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';

class VideoPlayerChewie extends StatefulWidget {
  const VideoPlayerChewie({
    super.key,
    required this.videoUrl,
    this.isLive = false,
  });

  final String videoUrl;
  final bool isLive;

  @override
  State<VideoPlayerChewie> createState() => _MyChewieVideoPlayerState();
}

class _MyChewieVideoPlayerState extends State<VideoPlayerChewie> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  int? bufferDelay;

  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    )..addListener(() {
      if (_videoPlayerController.value.hasError) {
        setState(() {
          errorMessage =
              _videoPlayerController.value.errorDescription ??
              "Unknown error occurred";
        });
      }
    });

    await Future.wait([_videoPlayerController.initialize()]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio:
          MediaQuery.sizeOf(context).width / MediaQuery.sizeOf(context).height,
      autoPlay: true,
      showOptions: !widget.isLive,
      controlsSafeAreaMinimum: const EdgeInsets.all(2),
      fullScreenByDefault: true,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      isLive: widget.isLive,
      hideControlsTimer: const Duration(seconds: 1),
      placeholder: const Center(child: CircularProgressIndicator.adaptive()),
      customControls: const CupertinoControls(
        backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
        iconColor: Color.fromARGB(255, 200, 200, 200),
      ),
      errorBuilder:
          (context, errorMessage) => Center(
            child: Text(
              errorMessage,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage.isNotEmpty) {
      return SafeArea(
        child: SizedBox(
          width: context.screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "An error occurred.",
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.redAccent),
                ),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    errorMessage = "";
                  });
                  initializePlayer();
                },
                child: Text("Retry".hardcoded),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child:
          _chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized
              ? Chewie(controller: _chewieController!)
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CupertinoActivityIndicator(
                    radius: 25,
                    color: Colors.white54,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Loading...',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.white54),
                  ),
                ],
              ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}

class DelaySlider extends StatefulWidget {
  const DelaySlider({super.key, required this.delay, required this.onSave});

  final int? delay;
  final void Function(int?) onSave;
  @override
  State<DelaySlider> createState() => _DelaySliderState();
}

class _DelaySliderState extends State<DelaySlider> {
  int? delay;
  bool saved = false;

  @override
  void initState() {
    super.initState();
    delay = widget.delay;
  }

  @override
  Widget build(BuildContext context) {
    const int max = 1000;
    return ListTile(
      title: Text(
        "Progress indicator delay ${delay != null ? "${delay.toString()} MS" : ""}",
      ),
      subtitle: Slider(
        value: delay != null ? (delay! / max) : 0,
        onChanged: (value) async {
          delay = (value * max).toInt();
          setState(() {
            saved = false;
          });
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.save),
        onPressed:
            saved
                ? null
                : () {
                  widget.onSave(delay);
                  setState(() {
                    saved = true;
                  });
                },
      ),
    );
  }
}
