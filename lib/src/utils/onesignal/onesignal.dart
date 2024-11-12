import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:vs_live/src/config/env.dart';
import 'package:vs_live/src/utils/native_id.dart';

Future<void> initOnesignal() async {
  if (!kReleaseMode) {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  }

  OneSignal.initialize(Env.onesignalAppId);
  final granted = await OneSignal.Notifications.requestPermission(true);

  final deviceId = await getNativeDeviceId();
  if (deviceId != null && deviceId.isNotEmpty && granted) {
    log("Device: $deviceId");
    OneSignal.login(deviceId);
  }
}

Future<void> disablePush([bool disable = true]) async {
  if (disable) {
    OneSignal.User.pushSubscription.optOut();
  } else {
    final granted = await OneSignal.Notifications.requestPermission(true);
    if (granted) {
      OneSignal.User.pushSubscription.optIn();
    }
  }
}

bool? getPushSubsciption() {
  return OneSignal.User.pushSubscription.optedIn;
}
