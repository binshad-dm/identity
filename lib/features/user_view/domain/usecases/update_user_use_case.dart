import 'package:dartz/dartz.dart';
import 'package:identity/core/error/failure.dart';
import '../repositories/user_repository.dart';
import '../entities/update_user_request.dart';
import '../entities/user_entity.dart';

class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(UpdateUserRequest request) async {
    return await repository.updateUser(request);
  }
}
