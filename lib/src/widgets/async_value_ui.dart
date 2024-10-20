import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vs_live/src/errors/exceptions.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';

/// A helper [AsyncValue] extension to show an alert dialog on error
extension AsyncValueUI on AsyncValue {
  void showAlertDialogOnError(
    BuildContext context, {
    String? title,
  }) {
    if (!isLoading && hasError) {
      final message = _errorMessage(error);
      // showExceptionAlertDialog(
      //   context: context,
      //   title: title ?? 'Error'.hardcoded,
      //   exception: message,
      // );
      showAdaptiveDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title ?? 'Error'.hardcoded),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Ok".hardcoded),
            ),
          ],
        ),
      );
    }
  }

  String _errorMessage(Object? error) {
    if (error is AppException) {
      return error.message;
    } else {
      return error.toString();
    }
  }
}
