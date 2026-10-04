import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../app/env/env.dart';
import 'constants.dart';
import 'interceptors/safe_log_interceptor.dart';

abstract class DioClient {
  late final Dio dio;

  DioClient(Env env) {
    dio = Dio(BaseOptions(
      baseUrl: env.apiBaseUrl,
      connectTimeout: const Duration(seconds: Net.connectTimeoutSec),
      receiveTimeout: const Duration(seconds: Net.receiveTimeoutSec),
    ));

    configureDio();
    if (env.enableLogging && kDebugMode) {
      dio.interceptors.add(SafeLogInterceptor());
    }
  }

  void configureDio();
}
