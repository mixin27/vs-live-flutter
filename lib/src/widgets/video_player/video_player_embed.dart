import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class VideoPlayerEmbed extends StatefulWidget {
  const VideoPlayerEmbed({
    super.key,
    required this.embedString,
    this.keepAlive = false,
    this.aspectRatio = 16 / 9,
    this.backgroundColor,
  });

  final String embedString;
  final bool keepAlive;
  final double aspectRatio;
  final Color? backgroundColor;

  @override
  State<VideoPlayerEmbed> createState() => _VideoPlayerEmbedState();
}

class _VideoPlayerEmbedState extends State<VideoPlayerEmbed>
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
  void didUpdateWidget(covariant VideoPlayerEmbed oldWidget) {
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
    await _controller.loadHtmlString(widget.embedString);
  }

  void _updateBackgroundColor(Color? backgroundColor) {
    final bgColor = backgroundColor ?? Theme.of(context).colorScheme.surface;
    _controller.setBackgroundColor(bgColor);
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
