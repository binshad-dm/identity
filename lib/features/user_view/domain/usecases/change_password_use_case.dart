import 'package:dartz/dartz.dart';
import 'package:identity/core/error/failure.dart';
import '../repositories/user_repository.dart';

class ChangePasswordUseCase {
  final UserRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) {
    return repository.changePassword(userId, oldPassword, newPassword);
  }
}
