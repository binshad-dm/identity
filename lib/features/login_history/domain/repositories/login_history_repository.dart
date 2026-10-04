import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/models/paginated_response.dart';
import '../entities/login_history_entity.dart';

abstract class LoginHistoryRepository {
  Future<Either<Failure, PaginatedResponse<LoginHistoryEntity>>> getLoginHistory({
    String? username,
    int page = 1,
    int size = 10,
  });
}
