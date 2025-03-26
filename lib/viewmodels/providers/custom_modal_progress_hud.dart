import 'package:flutter/foundation.dart';

class CustomModalProgressHudProvider with ChangeNotifier {
  bool _inAsyncCall = false;

  bool get inAsyncCall => _inAsyncCall;

  set inAsyncCall(bool value) {
    _inAsyncCall = value;
    notifyListeners();
  }
}
