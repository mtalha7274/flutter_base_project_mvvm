import 'package:flutter/material.dart';

class AppRouter {
  static Future<void> push(BuildContext context, Widget widget) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  static Future<void> pushReplacement(BuildContext context, Widget widget) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
