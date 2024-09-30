abstract class LocalStorageManager {
  int? getInt({required String key});
  Future<void> setInt({required String key, required int value});

  double? getDouble({required String key});
  Future<void> setDouble({required String key, required double value});

  String? getString({required String key});
  Future<void> setString({required String key, required String value});

  bool? getBool({required String key});
  Future<void> setBool({required String key, required bool value});

  List<String>? getListString({required String key});
  Future<void> setListString(
      {required String key, required List<String> value});
}
