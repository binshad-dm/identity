import 'package:dartz/dartz.dart';
import 'package:identity/core/error/failure.dart';
import 'package:identity/core/network/models/paginated_response.dart';
import '../entities/role_entity.dart';
import '../repositories/role_repository.dart';

class GetRolesUseCase {
  final RoleRepository repository;

  GetRolesUseCase(this.repository);

  Future<Either<Failure, PaginatedResponse<RoleEntity>>> call({
    required int page,
    required int size,
    String? search,
    String? status,
  }) {
    return repository.getRoles(
      page: page,
      size: size,
      search: search,
      status: status,
    );
  }
}
