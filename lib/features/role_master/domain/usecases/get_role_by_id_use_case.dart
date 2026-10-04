import 'package:dartz/dartz.dart';
import 'package:identity/core/error/failure.dart';
import '../entities/role_entity.dart';
import '../repositories/role_repository.dart';

class GetRoleByIdUseCase {
  final RoleRepository repository;

  GetRoleByIdUseCase(this.repository);

  Future<Either<Failure, RoleEntity>> call(String id) {
    return repository.getRoleById(id);
  }
}
