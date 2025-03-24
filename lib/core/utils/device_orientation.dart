import 'dart:io';

import 'package:flutter/services.dart';

Future<void> switchToLandscapeMode() async =>
    await SystemChrome.setPreferredOrientations([
      Platform.isAndroid
          ? DeviceOrientation.landscapeLeft
          : DeviceOrientation.landscapeRight
    ]);

Future<void> switchToPortraitMode() async =>
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
