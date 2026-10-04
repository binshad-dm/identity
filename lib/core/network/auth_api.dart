import 'package:dio/dio.dart';
import 'token_pair.dart';

class AuthApi {
  final Dio _dio;
  AuthApi(this._dio);
  Future<(Map<String, dynamic>, TokenPair)> login(String e, String p) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'userName': e, 'password': p},
      options: Options(
        extra: {'skipAuthRefresh': true},
      ),
    );
    final data = response.data as Map<String, dynamic>;
    final tokens = TokenPair(
      accessToken: data['accessToken'] as String? ?? '',
      refreshToken: data['refreshToken'] as String? ?? '',
    );
    return (data, tokens);
  }

  Future<TokenPair> refresh(String rt) async {
    final r = await _dio.post(
      '/auth/refresh',
      data: {'refreshToken': rt},
      options: Options(
        extra: {'skipAuthRefresh': true},
      ),
    );
    final d = r.data as Map<String, dynamic>;
    return TokenPair(
      accessToken: d['accessToken'] as String? ?? '',
      refreshToken: d['refreshToken'] as String? ?? rt,
    );
  }

  Future<void> logout(String token) async {
    await _dio.post(
      '/auth/logout',
      data: '',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        extra: {'skipAuthRefresh': true},
      ),
    );
  }

  Future<Map<String, dynamic>> getLoginHistory(String? token, String? username, int page, int size) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'size': size,
    };
    if (username != null && username.isNotEmpty) {
      queryParameters['username'] = username;
    }

    final options = (token != null && token.isNotEmpty)
        ? Options(
            headers: {'Authorization': 'Bearer $token'},
            extra: {'skipAuthRefresh': true},
          )
        : null;

    final response = await _dio.get(
      '/users/login-history',
      queryParameters: queryParameters,
      options: options,
    );
    return response.data as Map<String, dynamic>;
  }
}
