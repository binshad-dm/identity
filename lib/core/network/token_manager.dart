import '../storage/secure_store.dart';
import 'token_pair.dart';

class TokenManager {
  final SecureStore _s;
  final Future<String?> Function()? _externalTokenProvider;
  static const _A = 'auth_access_token';
  static const _R = 'auth_refresh_token';

  TokenManager(this._s, [this._externalTokenProvider]);

  Future<void> save(TokenPair p) async {
    await _s.write(_A, p.accessToken);
    await _s.write(_R, p.refreshToken);
  }

  Future<String?> getAccess() async {
    final provider = _externalTokenProvider;
    if (provider != null) {
      return await provider();
    }
    return _s.read(_A);
  }

  Future<String?> getRefresh() => _s.read(_R);

  Future<void> clear() async {
    await _s.delete(_A);
    await _s.delete(_R);
  }
}
