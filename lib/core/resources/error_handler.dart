import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logger/logger.dart';

import '../../data/managers/remote/api_manager_impl.dart';
import '../constants/view_constants.dart';
import 'data_state.dart';

class ErrorHandler {
  static Future<DataState<T>> onNetworkRequest<T>({
    String? referrence,
    required Future<dynamic> Function() fetch,
    FutureOr<T> Function(dynamic)? serialize,
  }) async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (!(connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.ethernet) ||
          connectivityResult.contains(ConnectivityResult.vpn))) {
        final error = ViewConstants.noInternet.tr();
        _showErrorInConsole(
            referrence: referrence, error: error, stackTrace: StackTrace.empty);
        return DataFailed(error);
      }

      if (serialize != null) {
        final response = await fetch();
        return DataSuccess<T>(await serialize(response));
      }

      final response = await fetch() as T;
      return DataSuccess<T>(response);
    } on HttpRequestException catch (e, s) {
      final errorMessage = e.message;
      _showErrorInConsole(
          referrence: referrence, error: e.error, stackTrace: s);
      return DataFailed(errorMessage);
    } on InvalidServerResponseException catch (e, s) {
      final errorMessage = e.message;
      _showErrorInConsole(
          referrence: referrence, error: e.error, stackTrace: s);
      return DataFailed(errorMessage);
    } on ErrorMessageFromServer catch (e, s) {
      final errorMessage = e.message;
      _showErrorInConsole(
          referrence: referrence, error: errorMessage, stackTrace: s);
      return DataFailed(errorMessage);
    } catch (e, s) {
      final error = e.toString();
      _showErrorInConsole(referrence: referrence, error: error, stackTrace: s);
      return DataFailed(error);
    }
  }

  static void _showErrorInConsole<T>({
    referrence,
    error,
    stackTrace,
  }) {
    Logger().e(referrence, error: error, stackTrace: stackTrace);
  }
}
