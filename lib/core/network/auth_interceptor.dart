import 'dart:async';

import 'package:dio/dio.dart';

import '../config/identity_config.dart';
import 'auth_api.dart';
import 'token_manager.dart';
import 'token_pair.dart';
import 'user_context.dart';

class _QueuedRequest {
  final RequestOptions requestOptions;
  final ErrorInterceptorHandler handler;
  final DioException originalError;

  _QueuedRequest({
    required this.requestOptions,
    required this.handler,
    required this.originalError,
  });
}

class AuthInterceptor extends Interceptor {
  final TokenManager tokenManager;
  final AuthApi authApi;
  final UserContext? userContext;
  final IdentityConfig? identityConfig;
  Dio? dio;

  final List<_QueuedRequest> _retryQueue = [];
  Completer<void>? _refreshCompleter;
  bool _isProcessingQueue = false;

  AuthInterceptor({
    required this.tokenManager,
    required this.authApi,
    this.userContext,
    IdentityConfig? identityConfig,
    IdentityConfig? opaConfig,
    this.dio,
  }) : identityConfig = identityConfig ?? opaConfig;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final a = await tokenManager.getAccess();
    if (a != null && a.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $a';
    }
    final studentId = userContext?.studentId;
    if (userContext?.isStudent == true &&
        studentId != null &&
        studentId.isNotEmpty) {
      options.headers['x-user'] = studentId;
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final skipRefresh = err.requestOptions.extra['skipAuthRefresh'] == true;
    final path = err.requestOptions.path;

    if (skipRefresh ||
        path.contains('/auth/login') ||
        path.contains('/auth/refresh')) {
      return handler.next(err);
    }

    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      // 1. Package Mode with external Refresh Token Handler
      if (identityConfig?.onRefreshToken != null) {
        _retryQueue.add(
          _QueuedRequest(
            requestOptions: err.requestOptions,
            handler: handler,
            originalError: err,
          ),
        );

        if (_refreshCompleter == null) {
          _refreshCompleter = Completer<void>();
          try {
            final newAccessToken = await identityConfig!.onRefreshToken!();
            if (newAccessToken == null || newAccessToken.isEmpty) {
              throw Exception('Refresh token returned null or empty');
            }
            await tokenManager.save(
              TokenPair(accessToken: newAccessToken, refreshToken: ''),
            );
            _refreshCompleter?.complete();
          } catch (e) {
            _refreshCompleter?.completeError(e);
            _rejectAllQueuedRequests(err);
            _retryQueue.clear();
            identityConfig?.onSessionExpired?.call();
            return;
          } finally {
            _refreshCompleter = null;
          }
        } else {
          try {
            await _refreshCompleter!.future;
          } catch (e) {
            return;
          }
        }

        if (!_isProcessingQueue) {
          _processQueuedRequests();
        }
        return;
      }

      // 2. Package Mode without refresh handler: direct session expired
      if (identityConfig != null) {
        identityConfig!.onSessionExpired?.call();
        return handler.next(err);
      }

      // 3. Standalone Dev Mode fallback
      _retryQueue.add(
        _QueuedRequest(
          requestOptions: err.requestOptions,
          handler: handler,
          originalError: err,
        ),
      );

      if (_refreshCompleter == null) {
        _refreshCompleter = Completer<void>();
        try {
          final refreshToken = await tokenManager.getRefresh();
          if (refreshToken == null || refreshToken.isEmpty) {
            throw Exception('No refresh token available');
          }
          final newTokens = await authApi.refresh(refreshToken);
          await tokenManager.save(newTokens);
          _refreshCompleter?.complete();
        } catch (e) {
          _refreshCompleter?.completeError(e);
          _rejectAllQueuedRequests(err);
          _retryQueue.clear();
          return;
        } finally {
          _refreshCompleter = null;
        }
      } else {
        try {
          await _refreshCompleter!.future;
        } catch (e) {
          return;
        }
      }

      if (!_isProcessingQueue) {
        _processQueuedRequests();
      }
      return;
    }

    handler.next(err);
  }

  Future<void> _processQueuedRequests() async {
    _isProcessingQueue = true;
    final targetDio = dio ?? Dio();

    while (_retryQueue.isNotEmpty) {
      final req = _retryQueue.removeAt(0);
      try {
        final newAccess = await tokenManager.getAccess();
        if (newAccess != null && newAccess.isNotEmpty) {
          req.requestOptions.headers['Authorization'] = 'Bearer $newAccess';
        }

        final response = await targetDio.fetch(req.requestOptions);
        req.handler.resolve(response);
      } catch (e) {
        if (e is DioException) {
          req.handler.reject(e);
        } else {
          req.handler.reject(
            DioException(
              requestOptions: req.requestOptions,
              error: e,
            ),
          );
        }
      }
    }
    _isProcessingQueue = false;
  }

  void _rejectAllQueuedRequests(DioException err) {
    for (final req in _retryQueue) {
      req.handler.reject(
        DioException(
          requestOptions: req.requestOptions,
          error: 'Session expired or refresh failed',
          type: req.originalError.type,
          response: req.originalError.response,
        ),
      );
    }
  }
}
