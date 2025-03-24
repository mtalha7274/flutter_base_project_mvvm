import 'package:flutter/material.dart';

import '../config.dart';
import 'language.dart';

/// To add a language in the app, add a translation in csv file placed in assets/translations
/// Then, add a key, local and label below.
/// Set a default language using defaultLanguage variable.
class LanguageConfig {
  // Keys
  static const List<String> _keys = [
    Config.english,
  ];

  // Locales
  static const Map<String, Locale> _locales = {
    Config.english: Locale('en', 'US'),
  };

  // Labels
  static const Map<String, String> _labels = {
    Config.english: "English",
  };

  static Language defaultLanguage(key) =>
      Language(name: _labels[key]!, locale: _locales[key]!);

  static List<Language> get languages => _keys
      .map((key) => Language(name: _labels[key]!, locale: _locales[key]!))
      .toList();
  static List<Locale> get locales => _locales.values.toList();
}
