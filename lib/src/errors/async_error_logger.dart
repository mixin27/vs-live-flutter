import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'error_logger.dart';
import 'exceptions.dart';

final class AsyncErrorLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    final errorLogger = AppErrorLogger();
    final error = _findError(newValue);
    if (error != null) {
      if (error.error is AppException) {
        // only prints the AppException data
        errorLogger.logException(error.error as AppException);
      } else {
        // prints everything including the stack trace
        errorLogger.logError(error.error, error.stackTrace);
      }
    }
  }

  AsyncError<dynamic>? _findError(Object? value) {
    if (value is AsyncError) {
      return value;
    } else {
      return null;
    }
  }
}
