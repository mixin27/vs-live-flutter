import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:vs_live/src/config/env.dart';

Future<void> initOnesignal() async {
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize(Env.onesignalAppId);

  OneSignal.Notifications.requestPermission(true);

  // final deviceId = await getNativeDeviceId();
  // if (deviceId != null) {
  //   log("Device: $deviceId");
  //   await OneSignal.login(deviceId);
  // }
}

Future<void> disablePush([bool disable = true]) async {
  if (disable) {
    OneSignal.User.pushSubscription.optOut();
  } else {
    OneSignal.User.pushSubscription.optIn();
  }
}

bool? getPushSubsciption() {
  return OneSignal.User.pushSubscription.optedIn;
}
