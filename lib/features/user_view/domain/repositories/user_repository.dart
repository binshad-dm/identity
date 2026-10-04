import 'package:dartz/dartz.dart';
import 'package:identity/core/error/failure.dart';
import 'package:identity/core/network/models/paginated_response.dart';
import '../entities/user_entity.dart';
import '../entities/user_detail_entity.dart';
import '../entities/create_user_request.dart';
import '../entities/update_user_request.dart';
import '../entities/role_select_item.dart';

abstract class UserRepository {
  Future<Either<Failure, PaginatedResponse<UserEntity>>> getUsers({
    String? search,
    String? role,
    String? status,
    int page = 1,
    int size = 10,
  });

  Future<Either<Failure, UserDetailEntity>> getUserDetail(String id);

  Future<Either<Failure, UserEntity>> createUser(CreateUserRequest request);

  Future<Either<Failure, void>> changePassword(
    String id,
    String oldPassword,
    String newPassword,
  );

  Future<Either<Failure, UserEntity>> updateUser(UpdateUserRequest request);

  Future<Either<Failure, void>> resetPassword(String id, String newPassword);
  Future<Either<Failure, void>> activateUser(String id);
  Future<Either<Failure, void>> deactivateUser(String id);

  Future<Either<Failure, List<RoleSelectItem>>> getRolesSelect();
  Future<Either<Failure, void>> updateUserRoles(String id, List<String> roles);
}
