import 'package:dio/dio.dart';
import 'tenant_manager.dart';

class TenantInterceptor extends Interceptor {
  final TenantManager tenant;
  TenantInterceptor(this.tenant);
  @override
  void onRequest(RequestOptions o, RequestInterceptorHandler h) {
    o.headers['X-Tenant-ID'] = tenant.tenantId;
    o.headers['X-Device-ID'] = tenant.deviceId;
    h.next(o);
  }
}
