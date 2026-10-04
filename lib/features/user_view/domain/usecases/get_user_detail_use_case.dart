import 'package:dartz/dartz.dart';
import 'package:identity/core/error/failure.dart';
import '../entities/user_detail_entity.dart';
import '../repositories/user_repository.dart';

class GetUserDetailUseCase {
  final UserRepository repository;

  GetUserDetailUseCase({required this.repository});

  Future<Either<Failure, UserDetailEntity>> call(String id) {
    return repository.getUserDetail(id);
  }
}
