import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// A custom logging interceptor that safely handles large payloads.
/// It truncates extremely long strings (like base64 image data) to prevent
/// the debug console from hanging or crashing during log rendering.
class SafeLogInterceptor extends Interceptor {
  final bool request;
  final bool requestHeader;
  final bool requestBody;
  final bool responseHeader;
  final bool responseBody;
  final bool error;

  /// Maximum length for a logged string before truncation occurs.
  static const int _maxLogLength = 1000;

  SafeLogInterceptor({
    this.request = true,
    this.requestHeader = true,
    this.requestBody = true,
    this.responseHeader = true,
    this.responseBody = true,
    this.error = true,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (request) {
      debugPrint('*** Request ***');
      debugPrint('uri: ${options.uri}');
    }
    if (requestHeader) {
      debugPrint('method: ${options.method}');
      debugPrint('headers:');
      options.headers.forEach((key, v) => debugPrint(' $key: $v'));
    }
    if (requestBody && options.data != null) {
      debugPrint('data:');
      _logData(options.data);
    }
    debugPrint('');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (request) {
      debugPrint('*** Response ***');
      debugPrint('uri: ${response.requestOptions.uri}');
    }
    if (responseHeader) {
      debugPrint('statusCode: ${response.statusCode}');
      if (response.headers.map.isNotEmpty) {
        debugPrint('headers:');
        response.headers.forEach((key, v) => debugPrint(' $key: $v'));
      }
    }
    if (responseBody) {
      debugPrint('Response Text:');
      _logData(response.data);
    }
    debugPrint('');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (error) {
      debugPrint('*** DioException ***');
      debugPrint('uri: ${err.requestOptions.uri}');
      debugPrint('$err');
      if (err.response != null) {
        _logData(err.response?.data);
      }
    }
    debugPrint('');
    handler.next(err);
  }

  void _logData(dynamic data) {
    if (data == null) return;

    if (data is Map) {
      final processed = _processValue(data);
      debugPrint(processed.toString());
    } else if (data is List) {
      final processed = _processValue(data);
      debugPrint(processed.toString());
    } else if (data is String) {
      debugPrint(_truncateString(data));
    } else {
      debugPrint(data.toString());
    }
  }

  dynamic _processValue(dynamic value) {
    if (value is String) {
      return _truncateString(value);
    } else if (value is Map) {
      return value.map((k, v) => MapEntry(k, _processValue(v)));
    } else if (value is List) {
      return value.map((v) => _processValue(v)).toList();
    }
    return value;
  }

  String _truncateString(String str) {
    if (str.length <= _maxLogLength) return str;
    
    // Truncate and show size metadata
    final prefix = str.substring(0, 50);
    final suffix = str.substring(str.length - 50);
    return '$prefix... [truncated ${str.length} chars] ...$suffix';
  }
}
