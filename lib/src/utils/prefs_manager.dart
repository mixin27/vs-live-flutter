import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vs_live/main.dart';

part 'prefs_manager.g.dart';

typedef PreferenceKey = String;

Future<SharedPreferences> getSharedPrefs() async {
  return SharedPreferences.getInstance();
}

class PreferenceManager {
  const PreferenceManager(this._prefs);

  final SharedPreferences _prefs;

  Future<bool> setData<T>(T data, PreferenceKey key) async {
    const invalidTypeError = 'Invalid Type';
    assert(
      T == String || T == bool || T == int || T == double || T == List<String>,
      invalidTypeError,
    );

    final setFuncs = <Type, Future<bool> Function()>{
      String: () => _prefs.setString(key, data as String),
      bool: () => _prefs.setBool(key, data as bool),
      int: () => _prefs.setInt(key, data as int),
      double: () => _prefs.setDouble(key, data as double),
      List<String>: () => _prefs.setStringList(key, data as List<String>),
    };

    final result = await (setFuncs[T] ?? () async => false)();
    return result;
  }

  T? getData<T>(PreferenceKey key) {
    const invalidTypeError = 'Invalid Type';
    assert(
      T == String || T == bool || T == int || T == double || T == List<String>,
      invalidTypeError,
    );

    final getFuncs = <Type, T? Function()>{
      String: () => _prefs.getString(key) as T?,
      bool: () => _prefs.getBool(key) as T?,
      int: () => _prefs.getInt(key) as T?,
      double: () => _prefs.getDouble(key) as T?,
      List<String>: () => _prefs.getStringList(key) as T?,
    };

    final data = getFuncs[T]?.call();
    return data;
  }
}

@riverpod
PreferenceManager preferenceManager(Ref ref) {
  return PreferenceManager(sharedPreferences);
}
