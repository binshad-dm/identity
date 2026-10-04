import 'package:identity/core/network/models/paginated_response.dart';

import '../models/role_model.dart';

abstract class RoleRemoteDataSource {
  Future<RoleModel> createRole(Map<String, dynamic> requestData);
  Future<PaginatedResponse<RoleModel>> getRoles({
    required int page,
    required int size,
    String? search,
    String? status,
  });
  Future<RoleModel> getRoleById(String id);
  Future<RoleModel> updateRole(String id, Map<String, dynamic> requestData);
  Future<void> activateRole(String id);
  Future<void> deactivateRole(String id);
}
