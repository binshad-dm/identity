import 'package:dartz/dartz.dart';
import 'package:identity/core/error/failure.dart';
import '../repositories/role_repository.dart';

class ActivateRoleUseCase {
  final RoleRepository repository;

  ActivateRoleUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.activateRole(id);
  }
}
