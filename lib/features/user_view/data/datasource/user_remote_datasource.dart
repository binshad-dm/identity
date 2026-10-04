import 'package:identity/core/network/models/paginated_response.dart';
import '../../domain/entities/role_select_item.dart';
import '../models/user_model.dart';
import '../models/user_detail_model.dart';

abstract class UserRemoteDataSource {
  /// Calls `GET /api/v1/users` with optional filters.
  Future<PaginatedResponse<UserModel>> getUsers({
    String? search,
    String? role,
    String? status,
    int page = 1,
    int size = 10,
  });

  /// Calls `GET /api/v1/users/{id}` to fetch full profile.
  Future<UserDetailModel> getUserDetail(String id);

  /// Calls `POST /api/v1/users` to create a new user.
  Future<UserModel> createUser(Map<String, dynamic> requestData);

  /// Calls `POST /api/v1/users/{id}/reset-password`
  Future<void> resetPassword(String id, String newPassword);

  /// Calls `POST /api/v1/users/{id}/activate`
  Future<void> activateUser(String id);

  /// Calls `POST /api/v1/users/{id}/deactivate`
  Future<void> deactivateUser(String id);

  /// Calls `POST /api/v1/users/{id}/change-password`.
  Future<void> changePassword(
    String id,
    String oldPassword,
    String newPassword,
  );

  /// Calls `PUT /api/v1/users/{id}` to update an existing user.
  Future<UserModel> updateUser(String id, Map<String, dynamic> requestData);

  /// Calls `GET /api/v1/roles/select` to fetch selectable roles.
  Future<List<RoleSelectItem>> getRolesSelect();

  /// Calls `PUT /api/v1/users/{id}/roles` to update roles.
  Future<void> updateUserRoles(String id, List<String> roles);
}
