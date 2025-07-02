import 'package:shared_preferences/shared_preferences.dart';
import 'package:vs_live/src/utils/extensions/dart_extensions.dart';
import 'package:vs_live/src/utils/format.dart';

class AppScheduler {
  static const prefix = "bsl_scheduler_";

  static String key(String name) => prefix + name;

  static Future<String?> readValue(String name) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key(name));
  }

  static Future<bool> readBool(String name) async {
    return (await readValue(name) ?? "") == "true";
  }

  static Future writeValue(String name, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key(name), value);
  }

  static Future writeBool(String name, bool value) async {
    return await writeValue(name, (value == true ? "true" : "false"));
  }

  static Future taskOnce(String name, Function() callback) async {
    String key = "${name}_once";
    bool alreadyExecuted = await readBool(key);
    if (!alreadyExecuted) {
      await writeBool(key, true);
      await callback();
    }
  }

  static Future taskDaily(
    String name,
    Function() callback, {
    DateTime? endAt,
  }) async {
    if (endAt != null && !endAt.isInFuture()) {
      return;
    }

    String key = "${name}_daily";
    String? lastTime = await readValue(key);

    if (lastTime == null || lastTime.isEmpty) {
      await _executeTaskAndSetDateTime(key, callback);
      return;
    }

    DateTime todayDateTime = now();
    DateTime lastDateTime = DateTime.parse(lastTime);
    Duration difference = todayDateTime.difference(lastDateTime);
    bool canExecute = (difference.inDays >= 1);

    if (canExecute) {
      // set the time
      await _executeTaskAndSetDateTime(key, callback);
    }
  }

  static Future _executeTaskAndSetDateTime(
    String key,
    Function() callback,
  ) async {
    DateTime dateTime = DateTime.now();
    await writeValue(key, dateTime.toString());

    await callback();
  }

  static Future taskOnceAfterDate(
    String name,
    Function() callback, {
    required DateTime date,
  }) async {
    /// Check if the date is in the past
    if (!date.isInPast()) {
      return;
    }
    String key = "${name}_after_date_$date";

    /// Check if we have already executed the task
    String keyExecuted = "${key}_executed";
    bool alreadyExecuted = await readBool(keyExecuted);

    if (!alreadyExecuted) {
      await writeBool(keyExecuted, true);
      await callback();
    }
  }
}
