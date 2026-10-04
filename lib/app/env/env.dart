import 'package:flutter/foundation.dart';
import '../../core/network/constants.dart';

class Env {
  final String apiBaseUrl;
  final String authBaseUrl;
  final bool enableLogging;
  final String flavor;

  const Env({
    required this.apiBaseUrl,
    required this.authBaseUrl,
    required this.enableLogging,
    required this.flavor,
  });

  static String _dartDefine(String key, String fallback) {
    // Cannot use const String.fromEnvironment directly with dynamic keys easily,
    // but typically we can check individual keys.
    // For simplicity, falling back to passed argument if not found.
    return fallback; 
  }

  static String _resolveBaseUrl(String url) {
    if (url.contains('localhost')) {
      if (kIsWeb) {
        return url;
      }
      final isAndroid = defaultTargetPlatform == TargetPlatform.android;
      if (isAndroid) {
        return url.replaceFirst('localhost', '10.0.2.2');
      }
    }
    return url;
  }


  factory Env.fromFlavor(String f) {
    final defaultApiUrl = _getDefaultApiUrl();
    final defaultAuthUrl = _getDefaultAuthUrl();
    
    // Hardcoding for now since _dartDefine needs literal keys
    const apiEnv = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    const authEnv = String.fromEnvironment('AUTH_BASE_URL', defaultValue: '');

    switch (f) {
      case 'prod':
        return Env(
          apiBaseUrl: _resolveBaseUrl(apiEnv.isEmpty ? defaultApiUrl : apiEnv),
          authBaseUrl: _resolveBaseUrl(authEnv.isEmpty ? defaultAuthUrl : authEnv),
          enableLogging: false,
          flavor: 'prod',
        );
      default:
        return Env(
          apiBaseUrl: _resolveBaseUrl(apiEnv.isEmpty ? defaultApiUrl : apiEnv),
          authBaseUrl: _resolveBaseUrl(authEnv.isEmpty ? defaultAuthUrl : authEnv),
          enableLogging: true,
          flavor: 'dev',
        );
    }
  }

  static String _getDefaultApiUrl() {
    if (kIsWeb) return 'http://localhost:8080${Net.apiPath}';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080${Net.apiPath}';
    }
    return 'http://localhost:8080${Net.apiPath}';
  }

  static String _getDefaultAuthUrl() {
    if (kIsWeb) return 'http://localhost:8085${Net.apiPath}';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8085${Net.apiPath}';
    }
    return 'http://localhost:8085${Net.apiPath}';
  }
}
