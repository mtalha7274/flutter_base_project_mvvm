import 'package:flutter/material.dart';

import '../config.dart';
import 'base.dart';

class LightTheme implements BaseTheme {
  @override
  final Color primary = const Color(0xFF0673ce);
  @override
  final Color onPrimary = const Color(0xFFffffff);
  @override
  final Color background = const Color(0xFFcce4f5);
  @override
  final Color surface = const Color(0xFFcce4f5);
  @override
  final Color secondaryBackground = const Color(0xFFffffff);
  @override
  final Color icon = const Color(0xFF000000);
  @override
  final Color secondaryText = const Color(0xFF717171);
  @override
  final Color primaryText = const Color(0xFF000000);
  @override
  final Color subtitle = const Color(0xFF3C3C43);

  @override
  late final ThemeData themeData = ThemeData(
      fontFamily: Config.fontFamily,
      iconTheme: IconThemeData(color: icon),
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(seedColor: primary));
}
