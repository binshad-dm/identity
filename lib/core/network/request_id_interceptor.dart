import 'package:dio/dio.dart';

class RequestIdInterceptor extends Interceptor {
  static String _nextId() => DateTime.now().microsecondsSinceEpoch.toString();
  @override
  void onRequest(RequestOptions o, RequestInterceptorHandler h) {
    o.headers['X-Request-ID'] = _nextId();
    h.next(o);
  }
}
