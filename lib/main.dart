import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vs_live/src/errors/async_error_logger.dart';
import 'package:vs_live/src/errors/error_logger.dart';
import 'package:vs_live/src/utils/ads/ads_helper.dart';
import 'package:vs_live/src/utils/localization/string_hardcoded.dart';

import 'src/app.dart';
import 'src/config/constants/app_sizes.dart';

late SharedPreferences sharedPreferences;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();
  await AdsHelper.initAds();

  // turn off the # in the URLs on the web
  usePathUrlStrategy();

  final container = ProviderContainer(
    observers: [AsyncErrorLogger()],
  );

  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  final errorLogger = container.read(errorLoggerProvider);
  registerErrorHandlers(errorLogger);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

void registerErrorHandlers(ErrorLogger errorLogger) {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    errorLogger.logError(details.exception, details.stack);

    // Crashlytics report will be here if needed
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    errorLogger.logError(error, stack);

    // Crashlytics report will be here if needed
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text('An error occurred'.hardcoded),
        ),
        body: ListView(
          padding: const EdgeInsets.all(Sizes.p8),
          children: [
            Text(details.toString()),
          ],
        ),
      ),
    );
  };
}
