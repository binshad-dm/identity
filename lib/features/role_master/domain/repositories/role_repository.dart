import 'package:dartz/dartz.dart';
import 'package:identity/core/error/failure.dart';
import 'package:identity/core/network/models/paginated_response.dart';
import '../entities/role_entity.dart';
import '../entities/create_role_request.dart';

abstract class RoleRepository {
  Future<Either<Failure, RoleEntity>> createRole(CreateRoleRequest request);
  Future<Either<Failure, PaginatedResponse<RoleEntity>>> getRoles({
    required int page,
    required int size,
    String? search,
    String? status,
  });
  Future<Either<Failure, RoleEntity>> getRoleById(String id);
  Future<Either<Failure, RoleEntity>> updateRole(
    String id,
    CreateRoleRequest request,
  );
  Future<Either<Failure, void>> activateRole(String id);
  Future<Either<Failure, void>> deactivateRole(String id);
}
