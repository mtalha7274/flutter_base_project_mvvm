import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_project_mvvm/core/extensions/string.dart';

class AppAnalytics {
  static void logScreenEvent(Screens screen) async {
    try {
      await FirebaseAnalytics.instance.logScreenView(
          screenName: screen.name.capitalizeFirst(),
          screenClass: screenClass[screen.name]);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static void logEvent(String eventName,
      {Map<String, Object>? parameters}) async {
    try {
      await FirebaseAnalytics.instance
          .logEvent(name: eventName, parameters: parameters);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static void setUserProperty(String name, String? value) async {
    try {
      await FirebaseAnalytics.instance
          .setUserProperty(name: name, value: value);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

enum Screens {
  splashScreen,
}

final Map screenClass = {
  Screens.splashScreen.name: 'Splash',
};
