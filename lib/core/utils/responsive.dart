import 'package:device_type/device_type.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../../config/config.dart';
import '../../main.dart';

enum RenderingDeviceType {
  phone,
  tablet,
  phablet,
}

extension RenderingDeviceTypeExtension on RenderingDeviceType {
  String get value {
    final name = toString().split('.').last;
    return name[0].toUpperCase() + name.substring(1);
  }
}

class Responsive {
  static double w(double pixels) => _scaleWidth(pixels);
  static double h(double pixels) => _scaleHeight(pixels);
  static double d(double pixels) =>
      min(_scaleWidth(pixels), _scaleHeight(pixels));
  static double r(double pixels) => d(pixels) / 2;

  static double f(double pixels) {
    final deviceType = DeviceType.getDeviceType(_context());
    if (!(deviceType == RenderingDeviceType.tablet.value)) {
      return pixels;
    }

    final (double w, double h) = _size();
    final (double dw, double dh) =
        (Config.designScreenWidth, Config.designScreenHeight);

    final deviceDiagonal = sqrt(w * w + h * h);
    final designDiagonal = sqrt(dw * dw + dh * dh);

    return (pixels / designDiagonal) * deviceDiagonal;
  }

  static double _scaleWidth(double pixels) {
    final (double w, _) = _size();
    return pixels * w / Config.designScreenWidth;
  }

  static double _scaleHeight(double pixels) {
    final (_, double h) = _size();
    return pixels * h / Config.designScreenHeight;
  }

  static (double w, double h) _size() {
    final context = _context();
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    final height = size.height - padding.vertical;
    final width = size.width - padding.horizontal;

    return (width, height);
  }

  static _context() => navigatorKey.currentContext!;
}
