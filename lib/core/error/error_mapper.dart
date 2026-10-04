import 'dart:convert';
import 'package:dio/dio.dart';
import 'app_exception.dart';
import 'failure.dart';

class ErrorMapper {
  static Failure from(Object e) {
    try {
      if (e is DioException) {
        final s = e.response?.statusCode ?? 0;
        final path = e.requestOptions.path;
        dynamic data = e.response?.data;
        Map<String, dynamic>? errorMap;

        if (data is Map) {
          try {
            errorMap = Map<String, dynamic>.from(data);
          } catch (_) {
            errorMap = data.map((k, v) => MapEntry(k.toString(), v));
          }
        } else if (data is String && data.isNotEmpty) {
          try {
            final decoded = jsonDecode(data);
            if (decoded is Map) {
              errorMap = Map<String, dynamic>.from(decoded);
            }
          } catch (_) {}
        }

        String? extractedMessage;
        String? extractedErrorCode;

        if (errorMap != null) {
          final detail = errorMap['detail']?.toString();
          final message = errorMap['message']?.toString();
          final title = errorMap['title']?.toString();
          final error = errorMap['error']?.toString();
          final properties = errorMap['properties'];
          final propCode =
              properties is Map ? properties['errorCode']?.toString() : null;
          final errorCode =
              propCode ?? errorMap['errorCode']?.toString() ?? title;

          extractedErrorCode = errorCode;

          // Return the most specific message available
          if (detail != null && detail.isNotEmpty) {
            extractedMessage = detail;
          } else if (message != null && message.isNotEmpty) {
            extractedMessage = message;
          } else if (title != null && title.isNotEmpty) {
            extractedMessage = title;
          } else if (error != null && error.isNotEmpty) {
            extractedMessage = error;
          } else if (errorCode != null && errorCode.isNotEmpty) {
            extractedMessage = errorCode;
          }
        } else if (data is String &&
            data.isNotEmpty &&
            !data.trim().startsWith('<')) {
          extractedMessage = data.trim();
        }

        // ── Auth errors ─────────────────────────────────────────────────────
        if (s == 401) {
          if (path.contains('/login')) {
            return const AuthFailure(
              'Invalid email/username or password. Please try again.',
            );
          }
          return AuthFailure(extractedMessage ?? 'Your session expired.');
        }

        if (s >= 400 && s < 500) {
          // Supervisor-only close endpoint fallback
          if (path.contains('/close')) {
            return const NetworkFailure(
              'Only a Supervisor can complete this case sheet.',
            );
          }

          if (extractedMessage != null && extractedMessage.isNotEmpty) {
            return NetworkFailure(
              extractedMessage,
              errorCode: extractedErrorCode,
            );
          }

          return const NetworkFailure(
            'Something went wrong. Please try again.',
          );
        }

        if (s >= 500) {
          if (extractedMessage != null && extractedMessage.isNotEmpty) {
            return NetworkFailure(
              extractedMessage,
              errorCode: extractedErrorCode,
            );
          }
          return const NetworkFailure(
            'Something went wrong. Please try again later.',
          );
        }

        // No status code (connection error, timeout, etc.)
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          return const NetworkFailure(
            'Connection timed out. Please check your network.',
          );
        }
        if (extractedMessage != null && extractedMessage.isNotEmpty) {
          return NetworkFailure(extractedMessage);
        }
        if (e.message != null && e.message!.isNotEmpty) {
          return NetworkFailure(e.message!);
        }
        return const NetworkFailure(
          'Unable to connect. Please check your network.',
        );
      }
      if (e is Failure) return e;
      if (e is AppException) return UnknownFailure(e.message);
      return UnknownFailure(e.toString());
    } catch (_) {
      return UnknownFailure(e.toString());
    }
  }
}
