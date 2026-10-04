import '../../../../core/network/auth_api.dart';
import 'login_history_remote_data_source.dart';

class LoginHistoryRemoteDataSourceImpl implements LoginHistoryRemoteDataSource {
  final AuthApi _authApi;

  LoginHistoryRemoteDataSourceImpl(this._authApi);

  @override
  Future<Map<String, dynamic>> getLoginHistory({
    String? token,
    String? username,
    int page = 1,
    int size = 10,
  }) async {
    return await _authApi.getLoginHistory(token, username, page, size);
  }
}
