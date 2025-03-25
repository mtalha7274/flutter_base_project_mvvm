import '../../../config/config.dart';
import '../../../core/constants/app_constants.dart';
import '../../managers/local/local_storage.dart';

class ThemeRepo {
  late final LocalStorageManager _manager;
  ThemeRepo(this._manager);

  String getTheme() {
    return _manager.getString(key: AppConstants.theme) ?? Config.defaultTheme;
  }

  Future<void> setTheme({required String theme}) async {
    await _manager.setString(key: AppConstants.theme, value: theme);
  }
}
