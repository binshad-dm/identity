abstract class LoginHistoryRemoteDataSource {
  Future<Map<String, dynamic>> getLoginHistory({
    String? token,
    String? username,
    int page = 1,
    int size = 10,
  });
}
