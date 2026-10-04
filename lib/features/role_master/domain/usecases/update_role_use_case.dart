import 'package:dartz/dartz.dart';
import 'package:identity/core/error/failure.dart';
import '../entities/role_entity.dart';
import '../entities/create_role_request.dart';
import '../repositories/role_repository.dart';

class UpdateRoleUseCase {
  final RoleRepository repository;

  UpdateRoleUseCase(this.repository);

  Future<Either<Failure, RoleEntity>> call(
    String id,
    CreateRoleRequest request,
  ) {
    return repository.updateRole(id, request);
  }
}
