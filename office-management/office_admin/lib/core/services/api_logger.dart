import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';

class ApiLogger extends Interceptor {
  ApiLogger({required this.enabled});

  final bool enabled;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (enabled) {
      developer.log(
        const JsonEncoder.withIndent('  ').convert({
          'stage': 'request',
          'method': options.method,
          'url': options.uri.toString(),
          'headers': options.headers,
          'queryParameters': options.queryParameters,
          'body': options.data,
        }),
        name: 'ApiService',
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (enabled) {
      developer.log(
        const JsonEncoder.withIndent('  ').convert({
          'stage': 'response',
          'method': response.requestOptions.method,
          'url': response.requestOptions.uri.toString(),
          'statusCode': response.statusCode,
          'statusMessage': response.statusMessage,
          'data': response.data,
        }),
        name: 'ApiService',
      );
    }

    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    if (enabled) {
      developer.log(
        const JsonEncoder.withIndent('  ').convert({
          'stage': 'error',
          'method': err.requestOptions.method,
          'url': err.requestOptions.uri.toString(),
          'statusCode': err.response?.statusCode,
          'statusMessage': err.response?.statusMessage,
          'message': err.message,
          'response': err.response?.data,
        }),
        name: 'ApiService',
        error: err,
      );
    }

    handler.next(err);
  }
}
