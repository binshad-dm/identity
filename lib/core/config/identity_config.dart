import 'package:yaml/yaml.dart';

typedef TokenProvider = Future<String?> Function();
typedef RefreshTokenHandler = Future<String?> Function();
typedef SessionExpiredCallback = void Function();

/// Authenticated user representation passed by the host application.
class IdentityUser {
  final String id;
  final String userName;
  final String? email;

  const IdentityUser({
    required this.id,
    required this.userName,
    this.email,
  });

  factory IdentityUser.fromMap(Map<dynamic, dynamic> map) {
    return IdentityUser(
      id: (map['id'] ?? map['userId'] ?? '').toString(),
      userName: (map['userName'] ?? map['username'] ?? '').toString(),
      email: map['email']?.toString(),
    );
  }
}

/// Configuration contract supplied by the parent/host application
/// when initializing the Identity package.
class IdentityConfig {
  /// The backend API base URL for general services (e.g., 'https://api.yourdomain.com')
  final String baseUrl;

  /// The backend API base URL for Auth services (e.g., 'https://auth.yourdomain.com')
  final String? authBaseUrl;

  /// Dedicated base URL for user-module services (e.g., 'https://users.yourdomain.com' or port 8081)
  final String? userBaseUrl;

  /// Dedicated base URL for role-module services (e.g., 'https://roles.yourdomain.com' or port 8085)
  final String? roleBaseUrl;

  /// Callback supplied by the host app to retrieve the current active JWT
  final TokenProvider getAccessToken;

  /// Optional callback to trigger token refresh in the host app on 401 Unauthorized
  final RefreshTokenHandler? onRefreshToken;

  /// Optional callback invoked when the session is expired/unauthorized
  final SessionExpiredCallback? onSessionExpired;

  /// Optional information about the currently logged-in host user
  final IdentityUser? currentUser;

  const IdentityConfig({
    required this.baseUrl,
    this.authBaseUrl,
    this.userBaseUrl,
    this.roleBaseUrl,
    required this.getAccessToken,
    this.onRefreshToken,
    this.onSessionExpired,
    this.currentUser,
  });

  /// Factory constructor to parse configuration from a dynamic Map (e.g. from JSON or YAML).
  factory IdentityConfig.fromMap(
    Map<dynamic, dynamic> map, {
    required TokenProvider getAccessToken,
    RefreshTokenHandler? onRefreshToken,
    SessionExpiredCallback? onSessionExpired,
    IdentityUser? currentUser,
  }) {
    return IdentityConfig(
      baseUrl: (map['base_url'] ?? map['baseUrl'] ?? '').toString(),
      authBaseUrl:
          map['auth_base_url']?.toString() ?? map['authBaseUrl']?.toString(),
      userBaseUrl:
          map['user_service_url']?.toString() ?? map['userBaseUrl']?.toString(),
      roleBaseUrl:
          map['role_service_url']?.toString() ?? map['roleBaseUrl']?.toString(),
      getAccessToken: getAccessToken,
      onRefreshToken: onRefreshToken,
      onSessionExpired: onSessionExpired,
      currentUser: currentUser,
    );
  }

  /// Factory constructor to parse configuration from a raw YAML string.
  factory IdentityConfig.fromYamlString(
    String yamlString, {
    required TokenProvider getAccessToken,
    RefreshTokenHandler? onRefreshToken,
    SessionExpiredCallback? onSessionExpired,
    IdentityUser? currentUser,
  }) {
    final doc = loadYaml(yamlString);
    final Map<dynamic, dynamic> map = doc is Map ? doc : {};
    final identityMap =
        map['identity'] is Map ? (map['identity'] as Map) : map;

    return IdentityConfig.fromMap(
      identityMap,
      getAccessToken: getAccessToken,
      onRefreshToken: onRefreshToken,
      onSessionExpired: onSessionExpired,
      currentUser: currentUser,
    );
  }
}
