import 'package:flutter/material.dart';

class AppRouter {
  static Future<T?> push<T extends Object?>(
      BuildContext context, Widget widget) async {
    return await Navigator.push(
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

  static Future<void> pushAndRemoveUntil(BuildContext context, Widget widget) {
    return Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => widget), (route) => false);
  }

  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }

  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }
}
