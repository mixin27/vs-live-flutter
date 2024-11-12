import 'package:flutter/material.dart';

class ErrorStatusIconWidget extends StatelessWidget {
  const ErrorStatusIconWidget({
    super.key,
    this.radius = 30,
    this.icon,
    this.size = 35,
    this.backgroundColor,
    this.foregroundColor,
  });

  final double radius;
  final IconData? icon;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      foregroundColor:
          foregroundColor ?? Theme.of(context).colorScheme.onSurface,
      radius: radius,
      child: Center(
        child: Icon(
          icon ?? Icons.error,
          size: size,
        ),
      ),
    );
  }
}
