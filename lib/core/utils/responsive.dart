import 'package:flutter/material.dart';

import '../../config/config.dart';
import '../../main.dart';

class Responsive {
  static double w(double pixelWidth) =>
      (pixelWidth / Config.designScreenWidth) *
      MediaQuery.of(navigatorKey.currentContext!).size.width;

  static double h(double pixelHeight) =>
      (pixelHeight / Config.designScreenHeight) *
      MediaQuery.of(navigatorKey.currentContext!).size.height;

  static double f(double pixelWidth, {double breakpoint = 600.0}) {
    final screenWidth = MediaQuery.of(navigatorKey.currentContext!).size.width;
    return (pixelWidth / Config.designScreenWidth) *
        (screenWidth > breakpoint ? breakpoint : screenWidth);
  }

  // Width with startpoint
  static double ws(double pixelWidth, {double startpoint = 480.0}) {
    final screenWidth = MediaQuery.of(navigatorKey.currentContext!).size.width;
    return screenWidth <= startpoint
        ? pixelWidth
        : (pixelWidth / Config.designScreenWidth) * screenWidth;
  }

  // Height with startpoint
  static double hs(double pixelHeight, {double startpoint = 640.0}) {
    final screenHeight =
        MediaQuery.of(navigatorKey.currentContext!).size.height;
    return screenHeight <= startpoint
        ? pixelHeight
        : (pixelHeight / Config.designScreenWidth) * screenHeight;
  }
}
