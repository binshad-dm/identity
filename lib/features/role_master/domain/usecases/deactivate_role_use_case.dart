import 'package:dartz/dartz.dart';
import 'package:identity/core/error/failure.dart';
import '../repositories/role_repository.dart';

class DeactivateRoleUseCase {
  final RoleRepository repository;

  DeactivateRoleUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deactivateRole(id);
  }
}
