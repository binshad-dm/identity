import 'package:dartz/dartz.dart';
import 'package:identity/core/error/failure.dart';
import '../repositories/role_repository.dart';
import '../entities/create_role_request.dart';
import '../entities/role_entity.dart';

class CreateRoleUseCase {
  final RoleRepository repository;

  CreateRoleUseCase(this.repository);

  Future<Either<Failure, RoleEntity>> call(CreateRoleRequest request) async {
    return await repository.createRole(request);
  }
}
