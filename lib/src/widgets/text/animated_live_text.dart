import 'package:flutter/material.dart';

import 'animated_text.dart';

class AnimatedLiveText extends AnimatedText {
  // ignore: use_super_parameters
  AnimatedLiveText(
    String text, {
    TextAlign textAlign = TextAlign.start,
    TextStyle? textStyle,
    Duration duration = const Duration(milliseconds: 2000),
    this.fadeInEnd = 0.5,
    this.fadeOutBegin = 0.8,
  })  : assert(fadeInEnd < fadeOutBegin,
            'The "fadeInEnd" argument must be less than "fadeOutBegin"'),
        super(
          text: text,
          textAlign: textAlign,
          textStyle: textStyle,
          duration: duration,
        );

  /// Marks ending of fade-in interval, default value = 0.5
  final double fadeInEnd;

  /// Marks the beginning of fade-out interval, default value = 0.8
  final double fadeOutBegin;

  late Animation<double> _fadeIn, _fadeOut;

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    return Opacity(
      opacity: _fadeIn.value != 1.0 ? _fadeIn.value : _fadeOut.value,
      child: textWidget(text),
    );
  }

  @override
  void initAnimation(AnimationController controller) {
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, fadeInEnd, curve: Curves.linear),
      ),
    );

    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(fadeOutBegin, 1.0, curve: Curves.linear),
      ),
    );
  }
}
