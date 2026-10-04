import 'package:dio/dio.dart';
import 'constants.dart';

class RetryInterceptor extends Interceptor {
  @override
  Future onError(DioException err, ErrorInterceptorHandler h) async {
    final req = err.requestOptions;
    final shouldRetry = (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.response?.statusCode ?? 0) >= 500);
    final retries = (req.extra['retries'] as int?) ?? 0;

    if (shouldRetry && retries < Net.retryCount) {
      req.extra['retries'] = retries + 1;
      try {
        final dio =
            req.extra['dio'] as Dio? ?? Dio(BaseOptions(baseUrl: req.baseUrl));
        final res = await dio.fetch(req);
        return h.resolve(res);
      } catch (e) {
        // If retry fails, pass the original or new error to the next interceptor
        if (e is DioException) {
          return h.next(e);
        }
        return h.next(err);
      }
    }
    return h.next(err);
  }
}
