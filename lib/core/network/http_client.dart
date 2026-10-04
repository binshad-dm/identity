import 'package:dio/dio.dart';
import '../storage/secure_store.dart';
import 'auth_api.dart';
import 'auth_interceptor.dart';
import 'token_manager.dart';
import 'tenant_interceptor.dart';
import 'tenant_manager.dart';
import 'request_id_interceptor.dart';
import 'retry_interceptor.dart';
import 'constants.dart';

Dio createAuthedDio({
  required String baseUrl,
  required SecureStore secureStore,
  required TenantManager tenantManager,
  bool enableLogging = false,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: Net.connectTimeoutSec),
      receiveTimeout: const Duration(seconds: Net.receiveTimeoutSec),
      validateStatus: (status) {
        return status != null && status >= 200 && status < 600;
      },
    ),
  );
  final tm = TokenManager(secureStore);
  final authApi = AuthApi(dio);
  dio.interceptors.add(RequestIdInterceptor());
  dio.interceptors.add(TenantInterceptor(tenantManager));
  dio.interceptors.add(AuthInterceptor(tokenManager: tm, authApi: authApi));
  dio.interceptors.add(RetryInterceptor());
  if (enableLogging) {
    dio.interceptors.add(
      LogInterceptor(requestBody: false, responseBody: false),
    );
  }
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (o, h) {
        o.extra['dio'] = dio;
        h.next(o);
      },
    ),
  );
  return dio;
}
