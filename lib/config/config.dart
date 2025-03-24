import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'languages/language.dart';
import 'languages/language_config.dart';

class Config {
  static final bool debug = dotenv.env['DEBUG'] == 'true';

// Languages
  static const String english = 'english';

// Themes
  static const String light = 'light';
  static const String dark = 'dark';

  // Config
  static const String fontFamily = 'Inter';
  static const String defaultTheme = light;
  static final Language defaultLanguage =
      LanguageConfig.defaultLanguage(english);
  static const double designScreenHeight = 812.0;
  static const double designScreenWidth = 375.0;
}
