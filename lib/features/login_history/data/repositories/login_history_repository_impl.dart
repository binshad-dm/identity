import 'package:dartz/dartz.dart';
import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/models/paginated_response.dart';
import '../../../../core/network/token_manager.dart';
import '../../domain/entities/login_history_entity.dart';
import '../../domain/repositories/login_history_repository.dart';
import '../datasources/login_history_remote_data_source.dart';

class LoginHistoryRepositoryImpl implements LoginHistoryRepository {
  final LoginHistoryRemoteDataSource _dataSource;
  final TokenManager _tokenManager;

  LoginHistoryRepositoryImpl(this._dataSource, this._tokenManager);

  @override
  Future<Either<Failure, PaginatedResponse<LoginHistoryEntity>>>
      getLoginHistory({String? username, int page = 1, int size = 10}) async {
    try {
      final token = await _tokenManager.getAccess();
      final responseMap = await _dataSource.getLoginHistory(
        token: token,
        username: username,
        page: page,
        size: size,
      );

      if (responseMap['pageNumber'] != null && responseMap['number'] == null) {
        responseMap['number'] = responseMap['pageNumber'];
      }
      if (responseMap['pageSize'] != null && responseMap['size'] == null) {
        responseMap['size'] = responseMap['pageSize'];
      }

      final paginated = PaginatedResponse<LoginHistoryEntity>.fromJson(
        responseMap,
        (json) => LoginHistoryEntity.fromJson(json as Map<String, dynamic>),
      );
      return Right(paginated);
    } catch (e) {
      return Left(ErrorMapper.from(e));
    }
  }
}
