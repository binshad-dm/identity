import 'package:flutter/material.dart';
import 'package:identity/core/design/theme/colors.dart';
import 'package:identity/core/design/widgets/app_status_badge.dart';
import 'package:identity/features/user_view/domain/entities/user_entity.dart';

class UserTable extends StatelessWidget {
  final List<UserEntity> users;
  final int startIndex;
  final Set<String> selectedIds;
  final Function(UserEntity) onEdit;
  final Function(UserEntity) onDelete;
  final Function(UserEntity) onResetPassword;
  final Function(UserEntity) onRoleManagement;
  final Function(UserEntity) onViewDetail;
  final Function(UserEntity) onToggleSelection;
  final Function(UserEntity) onToggleStatus;
  final VoidCallback onSelectAll;
  final VoidCallback onClearSelection;

  const UserTable({
    super.key,
    required this.users,
    required this.startIndex,
    required this.selectedIds,
    required this.onEdit,
    required this.onDelete,
    required this.onResetPassword,
    required this.onRoleManagement,
    required this.onViewDetail,
    required this.onToggleSelection,
    required this.onToggleStatus,
    required this.onSelectAll,
    required this.onClearSelection,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 48,
          ),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
            dataRowMinHeight: 64,
            dataRowMaxHeight: 72,
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Color(0xFF475569),
            ),
            columns: [
              const DataColumn(label: Text('Sl No.')),
              const DataColumn(label: Text('Username')),
              const DataColumn(label: Text('Full Name')),
              const DataColumn(label: Text('Email')),
              const DataColumn(label: Text('Status')),
              const DataColumn(label: Text('Roles')),
              const DataColumn(label: Text('Actions')),
            ],
            rows: users.asMap().entries.map((entry) {
              final index = entry.key;
              final user = entry.value;
              final isSelected = selectedIds.contains(user.id);

              return DataRow(
                color: WidgetStateProperty.all(
                  isSelected
                      ? AppColors.appThemeColorLight.withValues(alpha: 0.05)
                      : Colors.white,
                ),
                cells: [
                  DataCell(Text('${startIndex + index + 1}')),
                  // Username with avatar
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _UserAvatar(initials: user.initials),
                        const SizedBox(width: 10),
                        Text(
                          user.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Text(
                      user.fullName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  DataCell(
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                  // Status badge
                  DataCell(AppStatusBadge(status: user.status)),
                  // Roles chips
                  DataCell(
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: user.roles
                          .map((role) => _RoleChip(role: role))
                          .toList(),
                    ),
                  ),
                  // Action buttons
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.remove_red_eye_outlined,
                            size: 20,
                            color: AppColors.appThemeColorLight,
                          ),
                          onPressed: () => onViewDetail(user),
                          tooltip: 'View Details',
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: Color(0xFF64748B),
                          ),
                          onPressed: () => onEdit(user),
                          tooltip: 'Edit',
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            size: 20,
                            color: Color(0xFF64748B),
                          ),
                          onSelected: (value) {
                            debugPrint(
                              'DEBUG: PopupMenuButton onSelected: $value',
                            );
                            if (value == 'reset_password') {
                              onResetPassword(user);
                            } else if (value == 'role_management') {
                              onRoleManagement(user);
                            } else if (value == 'delete') {
                              onDelete(user);
                            } else if (value == 'toggle_status') {
                              onToggleStatus(user);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'role_management',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.admin_panel_settings_outlined,
                                    size: 20,
                                    color: Color(0xFF64748B),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Role Management'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'reset_password',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.lock_reset,
                                    size: 20,
                                    color: Color(0xFF64748B),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Reset Password'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'toggle_status',
                              child: Row(
                                children: [
                                  Icon(
                                    user.status == 'ACTIVE'
                                        ? Icons.block
                                        : Icons.check_circle_outline,
                                    size: 20,
                                    color: const Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    user.status == 'ACTIVE'
                                        ? 'Deactivate'
                                        : 'Activate',
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ─── Private sub-widgets ───────────────────────────────────────────────────

class _UserAvatar extends StatelessWidget {
  final String initials;
  const _UserAvatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: AppColors.appThemeColorLight.withValues(alpha: 0.15),
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.appThemeColorLight,
        ),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String role;
  const _RoleChip({required this.role});

  static const _roleColors = {
    'ADMIN': Color(0xFF7C3AED),
    'USER': Color(0xFF0284C7),
    'DOCTOR': Color(0xFF0F766E),
  };

  @override
  Widget build(BuildContext context) {
    final color = _roleColors[role] ?? const Color(0xFF6B7280);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        role,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
