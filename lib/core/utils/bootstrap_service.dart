import 'package:shared_preferences/shared_preferences.dart';
import '../network/tenant_manager.dart';
import '../network/token_manager.dart';
import '../storage/secure_store.dart';

class BootstrapService {
  final SecureStore secureStore;
  final TenantManager tenantManager;
  final TokenManager tokenManager;
  final SharedPreferences prefs;

  BootstrapService({
    required this.secureStore,
    required this.tenantManager,
    required this.tokenManager,
    required this.prefs,
  });

  Future<void> init() async {
    await tenantManager.loadTenant();

    await tokenManager.getAccess();
    await tokenManager.getRefresh();
  }
}
