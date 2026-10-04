import 'package:dio/dio.dart';

class CustomHeaderInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Basic headers required by the swagger sample
    options.headers['accept'] = '*/*';

    // X-USER and X-AUTHORITIES as requested.
    // Defaulting X-USER to '1' as per sample.
    // if (!options.headers.containsKey('X-USER')) {
    //   options.headers['X-USER'] = 'stub-user';
    // }

    // Dynamic X-AUTHORITIES
    final permission = options.extra['permission'];
    if (permission != null) {
      options.headers['X-AUTHORITIES'] = permission.toString();
    }

    super.onRequest(options, handler);
  }
}
