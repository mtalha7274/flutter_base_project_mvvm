import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:provider/provider.dart';

import 'config/config.dart';
import 'config/languages/language_config.dart';
import 'core/constants/app_assets.dart';
import 'core/utils/device_orientation.dart';
import 'injection_container.dart';
import 'viewmodels/language_provider.dart';
import 'viewmodels/theme_provider.dart';
import 'views/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  await switchToPortraitMode();
  try {
    if (Config.debug) {
      FlavorConfig(name: "DEBUG", location: BannerLocation.topEnd);
    }
    await EasyLocalization.ensureInitialized();
    runApp(EasyLocalization(
        assetLoader: CsvAssetLoader(),
        path: AppAssets.translations,
        fallbackLocale: Config.defaultLanguage.locale,
        supportedLocales: LanguageConfig.locales,
        child: const MainApp()));
  } catch (e) {
    debugPrint(e.toString());
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<ThemeProvider>(create: (_) => sl()),
      ChangeNotifierProvider<LanguageProvider>(create: (_) => sl()),
    ], child: const BaseApp());
  }
}

class BaseApp extends StatefulWidget {
  const BaseApp({
    super.key,
  });

  @override
  State<BaseApp> createState() => _BaseAppState();
}

class _BaseAppState extends State<BaseApp> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return FlavorBanner(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        color: themeProvider.baseTheme.primary,
        theme: themeProvider.baseTheme.themeData,
        home: const Splash(),
      ),
    );
  }
}
