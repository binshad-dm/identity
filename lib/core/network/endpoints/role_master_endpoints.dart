class RoleMasterEndpoints {
  static const String _base = '/roles';

  /// `GET /roles` — paginated role list
  static const String list = _base;

  /// `GET /roles/{id}` — get role by ID
  static String getRoleById(String id) => '$_base/$id';

  /// `POST /roles` — create role
  static const String createRole = _base;

  /// `PUT /roles/{id}` — update role
  static String updateRole(String id) => '$_base/$id';

  /// `POST /roles/{id}/activate` — activate role
  static String activateRole(String id) => '$_base/$id/activate';

  /// `POST /roles/{id}/deactivate` — deactivate role
  static String deactivateRole(String id) => '$_base/$id/deactivate';
}
