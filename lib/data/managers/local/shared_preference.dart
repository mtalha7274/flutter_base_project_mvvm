import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage.dart';

class SharedPreferenceManager implements LocalStorageManager {
  final SharedPreferences _preferences;
  const SharedPreferenceManager(this._preferences);

  @override
  bool? getBool({required String key}) {
    return _preferences.getBool(key);
  }

  @override
  double? getDouble({required String key}) {
    return _preferences.getDouble(key);
  }

  @override
  int? getInt({required String key}) {
    return _preferences.getInt(key);
  }

  @override
  List<String>? getListString({required String key}) {
    return _preferences.getStringList(key);
  }

  @override
  String? getString({required String key}) {
    return _preferences.getString(key);
  }

  @override
  Future<void> setBool({required String key, required bool value}) async {
    await _preferences.setBool(key, value);
  }

  @override
  Future<void> setDouble({required String key, required double value}) async {
    await _preferences.setDouble(key, value);
  }

  @override
  Future<void> setInt({required String key, required int value}) async {
    await _preferences.setInt(key, value);
  }

  @override
  Future<void> setListString(
      {required String key, required List<String> value}) async {
    await _preferences.setStringList(key, value);
  }

  @override
  Future<void> setString({required String key, required String value}) async {
    await _preferences.setString(key, value);
  }
}
