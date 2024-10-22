import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/providers/video_link_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IframePlayer extends ConsumerStatefulWidget {
  const IframePlayer({
    super.key,
    this.title = "Video Player",
    this.aspectRatio = 16 / 9,
  });

  final String title;
  final double aspectRatio;

  @override
  ConsumerState<IframePlayer> createState() => _IframePlayerState();
}

class _IframePlayerState extends ConsumerState<IframePlayer> {
  WebViewController? _controller;

  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _init() async {
    final videoUrl = ref.watch(videoLinkStateProvider);
    final playerHtml = await rootBundle.loadString("assets/player.html");
    final playerData = {
      'title': widget.title,
      'videoLink': videoUrl,
    };
    final preparedHtmlString = playerHtml.replaceAllMapped(
      RegExp(r'<<([a-zA-Z]+)>>'),
      (m) => playerData[m.group(1)] ?? m.group(0)!,
    );

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(preparedHtmlString);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      videoLinkStateProvider,
      (prev, state) async {
        if (prev != state) {
          await _init();
        }
      },
    );

    if (_controller == null) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }

    Widget player = WebViewWidget(controller: _controller!);

    return OrientationBuilder(
      builder: (context, orientation) {
        return AspectRatio(
          aspectRatio: orientation == Orientation.landscape
              ? MediaQuery.of(context).size.aspectRatio
              : widget.aspectRatio,
          child: Stack(
            children: [
              player,
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () {
                    if (!_isFullScreen) {
                      SystemChrome.setPreferredOrientations(
                        [
                          DeviceOrientation.landscapeLeft,
                          DeviceOrientation.landscapeRight,
                        ],
                      );
                      SystemChrome.setEnabledSystemUIMode(
                          SystemUiMode.immersive);
                      setState(() {
                        _isFullScreen = true;
                      });
                    } else {
                      SystemChrome.setPreferredOrientations(
                        [
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitDown,
                        ],
                      );
                      SystemChrome.setEnabledSystemUIMode(
                          SystemUiMode.immersive);
                      setState(() {
                        _isFullScreen = false;
                      });
                    }
                  },
                  icon: Icon(
                    _isFullScreen
                        ? Icons.fullscreen_exit_outlined
                        : Icons.fullscreen_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
