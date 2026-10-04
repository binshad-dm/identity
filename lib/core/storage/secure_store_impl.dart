import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'secure_store.dart';

class SecureStoreImpl implements SecureStore {
  final FlutterSecureStorage _s;
  SecureStoreImpl({FlutterSecureStorage? i})
      : _s = i ?? const FlutterSecureStorage();
  @override
  Future<void> write(String k, String v) => _s.write(key: k, value: v);
  @override
  Future<String?> read(String k) => _s.read(key: k);
  @override
  Future<void> delete(String k) => _s.delete(key: k);
}
