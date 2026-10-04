import 'package:dio/dio.dart';
import 'dio_client.dart';
import 'custom_header_interceptor.dart';
import 'auth_interceptor.dart';
import 'tenant_interceptor.dart';
import 'request_id_interceptor.dart';
import 'retry_interceptor.dart';
import 'token_manager.dart';
import 'tenant_manager.dart';
import 'user_context.dart';
import 'auth_api.dart';
import '../config/identity_config.dart';

class AppDioClient extends DioClient {
  final TokenManager tokenManager;
  final TenantManager tenantManager;
  final UserContext userContext;
  final AuthApi authApi;
  final IdentityConfig? identityConfig;

  AppDioClient(
    super.env, {
    required this.tokenManager,
    required this.tenantManager,
    required this.userContext,
    required this.authApi,
    IdentityConfig? identityConfig,
    IdentityConfig? opaConfig,
  }) : identityConfig = identityConfig ?? opaConfig;

  @override
  void configureDio() {
    final authInterceptor = AuthInterceptor(
      tokenManager: tokenManager,
      authApi: authApi,
      userContext: userContext,
      identityConfig: identityConfig,
      dio: dio,
    );

    // Add interceptors in logical order
    dio.interceptors.addAll([
      RequestIdInterceptor(),
      TenantInterceptor(tenantManager),
      CustomHeaderInterceptor(),
      authInterceptor,
      RetryInterceptor(),
    ]);

    // Ensure dio is available in extra for specific use cases if needed
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.extra['dio'] = dio;
          handler.next(options);
        },
      ),
    );
  }
}
