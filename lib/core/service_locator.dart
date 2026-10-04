import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app/env/env.dart';
import 'config/identity_config.dart';
import 'storage/secure_store.dart';
import 'storage/secure_store_impl.dart';
import 'print/i_print_handler.dart';
import 'print/print_handler_factory.dart';
import 'network/tenant_manager.dart';
import 'network/token_manager.dart';
import 'network/user_context.dart';
import 'network/app_dio_client.dart';
import 'network/auth_api.dart';
import 'shared/snackbar.dart';

// Feature Injections
import '../features/user_view/user_view_injection.dart';
import '../features/role_master/role_master_injection.dart';
import '../features/login_history/login_history_injection.dart';

/// Isolated dependency container for the Identity package.
///
/// Using `GetIt.asNewInstance()` ensures this container is completely separated
/// from the host application's `GetIt.instance`, preventing collision errors.
final sl = GetIt.asNewInstance();

Future<void> initServiceLocator({IdentityConfig? config}) async {
  // If already initialized, reset cleanly before re-registering
  if (sl.isRegistered<Env>() || sl.isRegistered<Dio>()) {
    await resetServiceLocator();
  }

  // Environment Configuration
  final Env env;
  if (config != null) {
    env = Env(
      apiBaseUrl: config.baseUrl,
      authBaseUrl: config.authBaseUrl ?? config.baseUrl,
      enableLogging: kDebugMode,
      flavor: 'prod',
    );
  } else {
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    env = Env.fromFlavor(flavor);
  }
  sl.registerSingleton<Env>(env);

  // Core Services
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  sl.registerLazySingleton<SecureStore>(() => SecureStoreImpl());
  sl.registerLazySingleton<PrintHandler>(() => PrintHandlerImpl());
  sl.registerLazySingleton<TenantManager>(
    () => TenantManager(sl<SecureStore>()),
  );
  sl.registerSingleton<UserContext>(UserContext());
  sl.registerLazySingleton<NotificationManager>(() => NotificationManager());

  // Token Manager: accepts external host callback if provided
  sl.registerLazySingleton<TokenManager>(
    () => TokenManager(sl<SecureStore>(), config?.getAccessToken),
  );

  // Auth Dio & AuthApi for fallback / legacy dev mode
  sl.registerLazySingleton<Dio>(() {
    final authUrl = sl<Env>().authBaseUrl.isNotEmpty
        ? sl<Env>().authBaseUrl
        : sl<Env>().apiBaseUrl;
    final dio = Dio(
      BaseOptions(
        baseUrl: authUrl,
        connectTimeout: const Duration(milliseconds: 5000),
        receiveTimeout: const Duration(milliseconds: 5000),
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
    }
    return dio;
  }, instanceName: 'auth');

  sl.registerLazySingleton<AuthApi>(
    () => AuthApi(sl<Dio>(instanceName: 'auth')),
  );

  // Main HTTP Client
  sl.registerLazySingleton<Dio>(() {
    final dioClient = AppDioClient(
      sl<Env>(),
      tokenManager: sl<TokenManager>(),
      tenantManager: sl<TenantManager>(),
      userContext: sl<UserContext>(),
      authApi: sl<AuthApi>(),
      identityConfig: config,
    );
    return dioClient.dio;
  });

  // User-module Dio — targets userBaseUrl or port 8085
  sl.registerLazySingleton<Dio>(
    () {
      final userBaseUrl = config?.userBaseUrl ??
          sl<Env>().apiBaseUrl.replaceAll(':8080', ':8085');

      final dioClient = AppDioClient(
        Env(
          apiBaseUrl: userBaseUrl,
          authBaseUrl: sl<Env>().authBaseUrl,
          enableLogging: sl<Env>().enableLogging,
          flavor: sl<Env>().flavor,
        ),
        tokenManager: sl<TokenManager>(),
        tenantManager: sl<TenantManager>(),
        userContext: sl<UserContext>(),
        authApi: sl<AuthApi>(),
        identityConfig: config,
      );
      return dioClient.dio;
    },
    instanceName: 'userDio',
  );

  // Role-module Dio — targets roleBaseUrl or port 8085
  sl.registerLazySingleton<Dio>(
    () {
      final roleBaseUrl = config?.roleBaseUrl ??
          sl<Env>().apiBaseUrl.replaceAll(':8080', ':8085');

      final dioClient = AppDioClient(
        Env(
          apiBaseUrl: roleBaseUrl,
          authBaseUrl: sl<Env>().authBaseUrl,
          enableLogging: sl<Env>().enableLogging,
          flavor: sl<Env>().flavor,
        ),
        tokenManager: sl<TokenManager>(),
        tenantManager: sl<TenantManager>(),
        userContext: sl<UserContext>(),
        authApi: sl<AuthApi>(),
        identityConfig: config,
      );
      return dioClient.dio;
    },
    instanceName: 'roleDio',
  );

  // Feature Injections
  initUserViewInjection(sl);
  initRoleMasterInjection(sl);
  initLoginHistoryInjection(sl);
}

/// Clears all registrations and state in the isolated container.
Future<void> resetServiceLocator() async {
  await sl.reset();
}
