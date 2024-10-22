import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class VideoPlayerIframe extends StatefulWidget {
  const VideoPlayerIframe({
    super.key,
    required this.videoUrl,
    this.keepAlive = false,
    this.aspectRatio = 16 / 9,
    this.backgroundColor,
  });

  final String videoUrl;
  final bool keepAlive;
  final double aspectRatio;
  final Color? backgroundColor;

  @override
  State<VideoPlayerIframe> createState() => _VideoPlayerIframeState();
}

class _VideoPlayerIframeState extends State<VideoPlayerIframe>
    with AutomaticKeepAliveClientMixin {
  late final WebViewController _controller;

  final Completer<void> _initCompleter = Completer();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    late final PlatformWebViewControllerCreationParams webViewParams;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      webViewParams = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      webViewParams = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(webViewParams)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false);

    await _loadVideo();
    if (!_initCompleter.isCompleted) _initCompleter.complete();
  }

  @override
  void didUpdateWidget(covariant VideoPlayerIframe oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.backgroundColor != oldWidget.backgroundColor) {
      _updateBackgroundColor(widget.backgroundColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget player = WebViewWidget(controller: _controller);

    return OrientationBuilder(
      builder: (context, orientation) {
        return AspectRatio(
          aspectRatio: orientation == Orientation.landscape
              ? MediaQuery.sizeOf(context).aspectRatio
              : widget.aspectRatio,
          child: player,
        );
      },
    );
  }

  Future<void> _loadVideo() async {
    final playerData = {
      'playerId': "VideoPlayer$hashCode",
      'videoLink': widget.videoUrl,
    };

    await _controller.loadHtmlString(
      await _buildPlayerHTML(playerData),
    );
  }

  Future<String> _buildPlayerHTML(Map<String, String> data) async {
    final playerHtml = await rootBundle.loadString(
      'assets/player.html',
    );

    return playerHtml.replaceAllMapped(
      RegExp(r'<<([a-zA-Z]+)>>'),
      (m) => data[m.group(1)] ?? m.group(0)!,
    );
  }

  void _updateBackgroundColor(Color? backgroundColor) {
    final bgColor = backgroundColor ?? Theme.of(context).colorScheme.surface;
    _controller.setBackgroundColor(bgColor);
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
