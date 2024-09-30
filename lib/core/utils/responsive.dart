import 'package:flutter/material.dart';

import '../../config/config.dart';

class Responsive {
  static late final double _screenWidth;
  static late final double _screenHeight;
  static const double _tabletWidth = 600.0;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;
  }

  static double w(double pixelWidth) =>
      (pixelWidth / Config.designScreenWidth) * _screenWidth;

  static double h(double pixelHeight) =>
      (pixelHeight / Config.designScreenHeight) * _screenHeight;

  static double f(double pixelWidth) =>
      (pixelWidth / Config.designScreenWidth) *
      (_screenWidth > _tabletWidth ? _tabletWidth : _screenWidth);
}
