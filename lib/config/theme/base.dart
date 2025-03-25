import 'package:flutter/material.dart';

abstract class BaseTheme {
  Color get primary;
  Color get onPrimary;
  Color get background;
  Color get surface;
  Color get icon;
  Color get secondaryBackground;
  Color get primaryText;
  Color get secondaryText;
  Color get subtitle;

  ThemeData get themeData;
}
