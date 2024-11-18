import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsUtil {
  static void logScreenView({String? screenName}) {
    if (!kReleaseMode) return;
    log("[screen_view] $screenName");
    FirebaseAnalytics.instance.logScreenView(screenName: screenName);
  }
}
