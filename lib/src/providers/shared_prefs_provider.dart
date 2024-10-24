import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vs_live/src/utils/prefs_manager.dart';

part 'shared_prefs_provider.g.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) {
  final completer = Completer<SharedPreferences>();
  SharedPreferences.getInstance().then((value) {
    completer.complete(value);
  });
  return completer.future;
}

@Riverpod(keepAlive: true)
Future<PreferenceManager> prefsManager(PrefsManagerRef ref) {
  final completer = Completer<PreferenceManager>();
  SharedPreferences.getInstance().then((value) {
    final prefsManager = PreferenceManager(value);
    completer.complete(prefsManager);
  });
  return completer.future;
}
