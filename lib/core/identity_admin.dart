import 'package:flutter/services.dart' show rootBundle;
import 'config/identity_config.dart';
import 'service_locator.dart';

/// Entry facade for the Identity package.
///
/// Host applications should initialize this SDK once:
/// ```dart
/// await IdentityAdmin.initialize(
///   config: IdentityConfig(
///     baseUrl: 'https://api.yourdomain.com',
///     getAccessToken: () async => await myAuthStorage.getToken(),
///     onRefreshToken: () async => await myAuthStorage.refreshToken(),
///     onSessionExpired: () => myNavigator.pushReplacementNamed('/login'),
///     currentUser: IdentityUser(id: 'u-123', userName: 'admin'),
///   ),
/// );
/// ```
///
/// Or initialize from a YAML configuration asset:
/// ```dart
/// await IdentityAdmin.initializeFromYaml(
///   'assets/config/identity.yaml',
///   getAccessToken: () async => await myAuthStorage.getToken(),
/// );
/// ```
class IdentityAdmin {
  static IdentityConfig? _config;

  /// Returns the current configuration, or null if not yet initialized.
  static IdentityConfig? get config => _config;

  /// Whether the SDK has been initialized with a valid configuration.
  static bool get isInitialized => _config != null;

  /// Initializes the Identity SDK with a programmatic configuration and sets up
  /// the internal isolated dependency container.
  static Future<void> initialize({required IdentityConfig config}) async {
    _config = config;
    await initServiceLocator(config: config);
  }

  /// Initializes the Identity SDK by reading configuration from a YAML asset path.
  static Future<void> initializeFromYaml(
    String yamlAssetPath, {
    required TokenProvider getAccessToken,
    RefreshTokenHandler? onRefreshToken,
    SessionExpiredCallback? onSessionExpired,
    IdentityUser? currentUser,
  }) async {
    final yamlString = await rootBundle.loadString(yamlAssetPath);
    final config = IdentityConfig.fromYamlString(
      yamlString,
      getAccessToken: getAccessToken,
      onRefreshToken: onRefreshToken,
      onSessionExpired: onSessionExpired,
      currentUser: currentUser,
    );
    await initialize(config: config);
  }

  /// Cleans up cached state, repositories, and dependency instances inside the SDK upon host user logout.
  static Future<void> reset() async {
    await resetServiceLocator();
    _config = null;
  }
}
