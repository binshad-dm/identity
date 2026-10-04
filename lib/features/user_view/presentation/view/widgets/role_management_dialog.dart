import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:identity/core/design/theme/colors.dart';
import 'package:identity/core/design/widgets/app_button.dart';
import 'package:identity/features/user_view/domain/entities/role_select_item.dart';
import 'package:identity/features/user_view/domain/entities/user_entity.dart';
import '../../view_model/user_cubit.dart';
import '../../view_model/user_state.dart';

class RoleManagementDialog extends StatefulWidget {
  final UserEntity user;

  const RoleManagementDialog({super.key, required this.user});

  @override
  State<RoleManagementDialog> createState() => _RoleManagementDialogState();
}

class _RoleManagementDialogState extends State<RoleManagementDialog> {
  bool _isLoading = true;
  String? _errorMessage;
  List<RoleSelectItem> _availableRoles = [];
  final Set<String> _selectedRoles = {};

  @override
  void initState() {
    super.initState();
    // Pre-populate existing user roles from user data list
    _selectedRoles.addAll(widget.user.roles);
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final roles = await context.read<UserCubit>().fetchRolesSelect();
      if (!mounted) return;
      setState(() {
        _availableRoles = roles;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onToggleRole(String roleName, bool? checked) {
    setState(() {
      if (checked == true) {
        _selectedRoles.add(roleName);
      } else {
        _selectedRoles.remove(roleName);
      }
    });
  }

  void _submit() {
    // Unique list of roles ensures no duplicates
    final rolesList = _selectedRoles.toList();
    context.read<UserCubit>().updateUserRoles(widget.user.id, rolesList);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserSuccess) {
          if (ModalRoute.of(context)?.isCurrent ?? false) {
            Navigator.of(context).pop();
          }
        }
        // else if (state is UserError) {
        //   showCustomSnackBar(
        //     context: context,
        //     message: state.message,
        //     type: SnackBarType.failure,
        //   );
        // }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480, maxHeight: 600),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.appThemeColorLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings_rounded,
                        color: AppColors.appThemeColorLight,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Role Management',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Assign roles for ${widget.user.userName}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, size: 20),
                      color: const Color(0xFF94A3B8),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 16),

                // Content area
                Expanded(child: _buildRoleList()),
                const SizedBox(height: 16),

                // Action buttons
                BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    final isSubmitting = state is UserLoading;
                    return Row(
                      children: [
                        Expanded(
                          child: AppOutlinedButton(
                            text: 'Cancel',
                            onPressed: isSubmitting
                                ? null
                                : () => Navigator.of(context).pop(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            text: isSubmitting ? 'Saving...' : 'Save Roles',
                            onPressed: (isSubmitting || _isLoading)
                                ? null
                                : _submit,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 36),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: _loadRoles, child: const Text('Retry')),
          ],
        ),
      );
    }

    // Combine available roles from API and any extra pre-existing roles from user if not present in API list
    final allRoleItems = List<RoleSelectItem>.from(_availableRoles);
    final existingNames = allRoleItems.map((r) => r.name).toSet();
    for (final roleStr in widget.user.roles) {
      if (!existingNames.contains(roleStr)) {
        allRoleItems.add(RoleSelectItem(id: roleStr, name: roleStr));
      }
    }

    if (allRoleItems.isEmpty) {
      return const Center(
        child: Text(
          'No roles available.',
          style: TextStyle(color: Color(0xFF64748B)),
        ),
      );
    }

    return ListView.separated(
      itemCount: allRoleItems.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final roleItem = allRoleItems[index];
        final isChecked =
            _selectedRoles.contains(roleItem.name) ||
            _selectedRoles.contains(roleItem.id);

        return Container(
          decoration: BoxDecoration(
            color: isChecked
                ? AppColors.appThemeColorLight.withValues(alpha: 0.05)
                : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isChecked
                  ? AppColors.appThemeColorLight.withValues(alpha: 0.3)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: CheckboxListTile(
            value: isChecked,
            onChanged: (checked) {
              _onToggleRole(roleItem.name, checked);
            },
            activeColor: AppColors.appThemeColorLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              roleItem.name,
              style: TextStyle(
                fontWeight: isChecked ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
                color: const Color(0xFF1E293B),
              ),
            ),
            subtitle: roleItem.id != roleItem.name
                ? Text(
                    'ID: ${roleItem.id}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                    ),
                  )
                : null,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 0,
            ),
          ),
        );
      },
    );
  }
}
