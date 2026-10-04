class UserEndpoints {
  static const String _base = 'users';

  /// `GET /api/v1/users` — paginated user list
  static const String list = _base;

  /// `GET /api/v1/users/{id}` — get user by ID
  static String getById(String id) => '$_base/$id';

  /// `POST /api/v1/users` — create user
  static const String createUser = _base;

  /// `POST /api/v1/users/{id}/change-password` — change user password
  static String changePassword(String id) => '$_base/$id/change-password';

  /// `PUT /api/v1/users/{id}` — update user by ID
  static String updateUser(String id) => '$_base/$id';

  /// `POST /api/v1/users/{id}/reset-password`
  static String resetPassword(String id) => '$_base/$id/reset-password';

  /// `POST /api/v1/users/{id}/activate`
  static String activate(String id) => '$_base/$id/activate';

  /// `POST /api/v1/users/{id}/deactivate`
  static String deactivate(String id) => '$_base/$id/deactivate';

  /// `PUT /api/v1/users/{id}/roles` — update user roles
  static String updateUserRoles(String id) => '$_base/$id/roles';

  /// `GET /api/v1/roles/select` — fetch select list of roles
  static const String rolesSelect = 'roles/select';
}
