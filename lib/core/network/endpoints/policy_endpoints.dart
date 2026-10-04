class PolicyEndpoints {
  static const String policies = '/internal/authz/policies';
  static String fields(String permissionCode) =>
      '/internal/authz/permissions/$permissionCode/fields';
  static const String namespaces = '/internal/authz/namespaces';
  static const String roles = '/api/v1/roles';
  static const String users = '/api/v1/users';
}
