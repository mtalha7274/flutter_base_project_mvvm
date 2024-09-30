import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/managers/local/local_storage.dart';
import 'data/managers/local/shared_preference.dart';
import 'data/repositories/language.dart';
import 'data/repositories/theme.dart';
import 'viewmodels/language_provider.dart';
import 'viewmodels/theme_provider.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Initialize
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Register Dependencies
  sl.registerSingleton<LocalStorageManager>(
      SharedPreferenceManager(sl<SharedPreferences>()));

  sl.registerSingleton<ThemeRepo>(ThemeRepo(sl<LocalStorageManager>()));
  sl.registerSingleton<LanguageRepo>(LanguageRepo(sl<LocalStorageManager>()));

  // Providers
  sl.registerFactory<ThemeProvider>(() => ThemeProvider(sl<ThemeRepo>()));
  sl.registerFactory<LanguageProvider>(
      () => LanguageProvider(sl<LanguageRepo>()));
}
