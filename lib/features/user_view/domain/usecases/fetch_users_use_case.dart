import 'package:dartz/dartz.dart';
import 'package:identity/core/error/failure.dart';
import 'package:identity/core/network/models/paginated_response.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class FetchUsersUseCase {
  final UserRepository repository;

  FetchUsersUseCase({required this.repository});

  Future<Either<Failure, PaginatedResponse<UserEntity>>> call({
    String? search,
    String? role,
    String? status,
    int page = 1,
    int size = 10,
  }) {
    return repository.getUsers(
      search: search,
      role: role,
      status: status,
      page: page,
      size: size,
    );
  }
}
