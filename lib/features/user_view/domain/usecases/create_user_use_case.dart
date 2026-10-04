import 'package:dartz/dartz.dart';
import 'package:identity/core/error/failure.dart';
import '../repositories/user_repository.dart';
import '../entities/create_user_request.dart';
import '../entities/user_entity.dart';

class CreateUserUseCase {
  final UserRepository repository;

  CreateUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(CreateUserRequest request) async {
    return await repository.createUser(request);
  }
}
