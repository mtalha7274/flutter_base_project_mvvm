import 'dart:io';

import 'package:flutter/services.dart';

void switchToLandscapeMode() => SystemChrome.setPreferredOrientations([
      Platform.isAndroid
          ? DeviceOrientation.landscapeLeft
          : DeviceOrientation.landscapeRight
    ]);

void switchToPortraitMode() =>
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
