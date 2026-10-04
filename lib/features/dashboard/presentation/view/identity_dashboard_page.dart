import 'package:flutter/material.dart';
import 'package:identity/features/login_history/presentation/view/login_history_page.dart';
import 'package:identity/features/role_master/presentation/view/role_list_page.dart';
import 'package:identity/features/user_view/presentation/view/user_list_page.dart';
import '../../../../core/config/identity_config.dart';
import '../../../../core/identity_admin.dart';

class IdentityDashboardPage extends StatefulWidget {
  final int initialIndex;

  const IdentityDashboardPage({super.key, this.initialIndex = 0});

  @override
  State<IdentityDashboardPage> createState() => _IdentityDashboardPageState();
}

class _IdentityDashboardPageState extends State<IdentityDashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onSelect(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHamburger() {
    return IconButton(
      icon: const Icon(Icons.menu_rounded, color: Color(0xFF0F172A)),
      tooltip: 'Open Navigation Menu',
      onPressed: () {
        _scaffoldKey.currentState?.openDrawer();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktopOrWeb = screenWidth >= 900;
    final activeUser = IdentityAdmin.config?.currentUser;

    final navItems = [
      _NavItem(
        title: 'User Master',
        subtitle: 'Manage user accounts and details',
        icon: Icons.people_alt_rounded,
        index: 0,
      ),
      _NavItem(
        title: 'User Roles',
        subtitle: 'Configure permissions and roles',
        icon: Icons.security_rounded,
        index: 1,
      ),
      _NavItem(
        title: 'Login History',
        subtitle: 'Audit logs and access events',
        icon: Icons.history_toggle_off_rounded,
        index: 2,
      ),
    ];

    final drawerContent = _DashboardDrawerContent(
      selectedIndex: _selectedIndex,
      navItems: navItems,
      activeUser: activeUser,
      onItemTapped: (index) {
        _onSelect(index);
        if (!isDesktopOrWeb &&
            _scaffoldKey.currentState?.isDrawerOpen == true) {
          Navigator.of(context).pop();
        }
      },
    );

    final leadingWidget = isDesktopOrWeb ? null : _buildHamburger();

    final pages = [
      UserListPage(leading: leadingWidget),
      RoleListPage(leading: leadingWidget),
      LoginHistoryPage(leading: leadingWidget),
    ];

    if (isDesktopOrWeb) {
      // Desktop / Web / Tablet Wide Layout: Persistent sleek sidebar
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF8FAFC),
        body: Row(
          children: [
            SizedBox(width: 270, child: drawerContent),
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: Color(0xFFE2E8F0),
            ),
            Expanded(
              child: IndexedStack(index: _selectedIndex, children: pages),
            ),
          ],
        ),
      );
    }

    // Tablet Narrow / Mobile Layout: Drawer navigation
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(child: drawerContent),
      backgroundColor: const Color(0xFFF8FAFC),
      body: IndexedStack(index: _selectedIndex, children: pages),
    );
  }
}

class _NavItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final int index;

  const _NavItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.index,
  });
}

class _DashboardDrawerContent extends StatelessWidget {
  final int selectedIndex;
  final List<_NavItem> navItems;
  final IdentityUser? activeUser;
  final ValueChanged<int> onItemTapped;

  const _DashboardDrawerContent({
    required this.selectedIndex,
    required this.navItems,
    required this.activeUser,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.shield_outlined,
                      color: primaryColor,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Identity',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // Active user profile badge if available
            if (activeUser != null)
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: primaryColor.withValues(alpha: 0.15),
                      child: Text(
                        activeUser!.userName.isNotEmpty
                            ? activeUser!.userName[0].toUpperCase()
                            : 'U',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activeUser!.userName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          if (activeUser!.email != null)
                            Text(
                              activeUser!.email!,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Navigation Items
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                itemCount: navItems.length,
                separatorBuilder: (_, _) => const SizedBox(height: 6),
                itemBuilder: (context, i) {
                  final item = navItems[i];
                  final isSelected = selectedIndex == item.index;

                  return Material(
                    color: isSelected
                        ? primaryColor.withValues(alpha: 0.08)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => onItemTapped(item.index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              size: 22,
                              color: isSelected
                                  ? primaryColor
                                  : const Color(0xFF64748B),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? primaryColor
                                          : const Color(0xFF1E293B),
                                    ),
                                  ),
                                  Text(
                                    item.subtitle,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isSelected
                                          ? primaryColor.withValues(alpha: 0.8)
                                          : const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Container(
                                width: 4,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // // Language Switcher (Rule 1: lib/core/l10n for language switching)
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            //   child: Row(
            //     children: [
            //       const Icon(
            //         Icons.language_rounded,
            //         size: 18,
            //         color: Color(0xFF64748B),
            //       ),
            //       const SizedBox(width: 8),
            //       const Text(
            //         'Language',
            //         style: TextStyle(
            //           fontSize: 13,
            //           color: Color(0xFF475569),
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //       const Spacer(),
            //       BlocBuilder<LocaleCubit, Locale>(
            //         builder: (context, locale) {
            //           return DropdownButton<String>(
            //             value: locale.languageCode,
            //             underline: const SizedBox(),
            //             icon: const Icon(
            //               Icons.keyboard_arrow_down_rounded,
            //               size: 18,
            //               color: Color(0xFF64748B),
            //             ),
            //             items: const [
            //               DropdownMenuItem(
            //                 value: 'en',
            //                 child: Text('EN', style: TextStyle(fontSize: 13)),
            //               ),
            //               DropdownMenuItem(
            //                 value: 'es',
            //                 child: Text('ES', style: TextStyle(fontSize: 13)),
            //               ),
            //               DropdownMenuItem(
            //                 value: 'ar',
            //                 child: Text('AR', style: TextStyle(fontSize: 13)),
            //               ),
            //             ],
            //             onChanged: (lang) {
            //               if (lang != null) {
            //                 context.read<LocaleCubit>().changeLocale(lang);
            //               }
            //             },
            //           );
            //         },
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
