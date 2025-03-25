import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';

import '../../../core/constants/view_constants.dart';
import 'api_manager.dart';
import 'package:http/http.dart' as http;

class ApiManagerImpl extends ApiManager {
  @override
  final String baseUrl;

  ApiManagerImpl(this.baseUrl);

  @override
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _onRequest(
        fetch: () async =>
            await http.get(url, headers: _mergeHeaders(headers)));
    return response;
  }

  @override
  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _onRequest(
        fetch: () async => await http.post(url,
            headers: _mergeHeaders(headers), body: jsonEncode(body)));
    return response;
  }

  @override
  Future<dynamic> put(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _onRequest(
        fetch: () async => await http.put(url,
            headers: _mergeHeaders(headers), body: jsonEncode(body)));
    return response;
  }

  @override
  Future<dynamic> delete(String endpoint,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _onRequest(
        fetch: () async =>
            await http.delete(url, headers: _mergeHeaders(headers)));
    return response;
  }

  @override
  Future<dynamic> uploadFile(
    String endpoint,
    File file, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await _onRequest(fetch: () async {
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll(_mergeHeaders(headers));
      request.files.add(await http.MultipartFile.fromPath('image', file.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return response;
    });
    return response;
  }

  Map<String, String> _mergeHeaders(Map<String, String>? customHeaders) {
    return {
      ...defaultHeaders,
      if (customHeaders != null) ...customHeaders,
    };
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      dynamic errorMessage;
      try {
        final decoded = jsonDecode(response.body);
        errorMessage = decoded['msg'] ?? decoded['error'];
      } catch (e, s) {
        _handleInvalidResponseException(
            response.statusCode, e, s, response.body);
      }

      _handleErrorMessageFromServer(response.statusCode, errorMessage);
    }
  }

  void _handleHttpRequestException(Object error, StackTrace stackTrace) {
    throw HttpRequestException(
        message: ViewConstants.serverError.tr(),
        error: error,
        stackTrace: stackTrace);
  }

  void _handleInvalidResponseException(
      int statusCode, Object error, StackTrace stackTrace, dynamic response) {
    throw InvalidServerResponseException(
        statusCode: statusCode,
        message: ViewConstants.invalidResponse.tr(),
        error: error,
        stackTrace: stackTrace,
        response: response);
  }

  void _handleErrorMessageFromServer(int statusCode, String message) {
    throw ErrorMessageFromServer(statusCode: statusCode, message: message);
  }

  Future<dynamic> _onRequest(
      {required Future<http.Response> Function() fetch}) async {
    try {
      final response = await fetch();
      return _handleResponse(response);
    } on InvalidServerResponseException {
      rethrow;
    } on ErrorMessageFromServer {
      rethrow;
    } catch (e, s) {
      _handleHttpRequestException(e, s);
    }
  }
}

class HttpRequestException implements Exception {
  final String message;
  final Object error;
  final StackTrace stackTrace;
  HttpRequestException(
      {required this.message, required this.error, required this.stackTrace});
}

class InvalidServerResponseException implements Exception {
  final String message;
  final int? statusCode;
  final Object? error;
  final StackTrace? stackTrace;
  final dynamic response;
  InvalidServerResponseException(
      {required this.message,
      this.statusCode,
      this.error,
      this.stackTrace,
      this.response});
}

class ErrorMessageFromServer implements Exception {
  final String message;
  final int statusCode;
  ErrorMessageFromServer({required this.message, required this.statusCode});
}
