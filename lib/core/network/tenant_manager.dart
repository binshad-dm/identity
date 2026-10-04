import '../../core/storage/secure_store.dart';

class TenantManager {
  final SecureStore _store;
  TenantManager(this._store);

  String _tenantId = 'default-tenant';
  String _deviceId = 'device-unknown';

  String get tenantId => _tenantId;
  String get deviceId => _deviceId;

  Future<void> setTenant(String id) async {
    _tenantId = id;
    await _store.write('tenant_id', id);
  }

  Future<void> loadTenant() async {
    final id = await _store.read('tenant_id');
    if (id != null) _tenantId = id;
  }

  void setDevice(String id) => _deviceId = id;
}
