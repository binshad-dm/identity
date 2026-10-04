import 'package:get/get.dart';

import '../../features/dashboard/presentation/view/identity_dashboard_page.dart';
import '../../features/user_view/presentation/view/user_list_page.dart';
import '../../features/role_master/presentation/view/role_list_page.dart';
import '../../features/login_history/presentation/view/login_history_page.dart';
import 'routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.dashboard;

  static final routes = [
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const IdentityDashboardPage(),
    ),
    GetPage(
      name: AppRoutes.authorizationDashboard,
      page: () => const IdentityDashboardPage(),
    ),
    GetPage(
      name: AppRoutes.userMaster,
      page: () => const UserListPage(),
    ),
    GetPage(
      name: AppRoutes.roleMaster,
      page: () => const RoleListPage(),
    ),
    GetPage(
      name: AppRoutes.loginHistory,
      page: () => const LoginHistoryPage(),
    ),
  ];
}
