import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:identity/core/design/theme/colors.dart';
import 'package:identity/core/design/widgets/app_appbar.dart';
import 'package:identity/core/design/widgets/app_button.dart';
import 'package:identity/core/design/widgets/app_status_badge.dart';
import 'package:identity/core/service_locator.dart';
import 'package:identity/core/shared/snackbar.dart';
import 'package:identity/features/role_master/domain/usecases/get_role_by_id_usecase.dart';
import 'package:identity/features/role_master/domain/usecases/get_roles_usecase.dart';
import 'package:identity/shared/component/pagination_component.dart';
import '../../domain/usecases/create_role_use_case.dart';

import '../../domain/usecases/update_role_use_case.dart';
import '../../domain/usecases/activate_role_use_case.dart';
import '../../domain/usecases/deactivate_role_use_case.dart';
import '../../domain/entities/role_entity.dart';
import '../view_model/role_cubit.dart';
import '../view_model/role_state.dart';
import 'widgets/role_create_dialog.dart';
import 'widgets/role_detail_dialog.dart';

class RoleListPage extends StatelessWidget {
  final bool showAppBar;
  final Widget? leading;

  const RoleListPage({
    super.key,
    this.showAppBar = true,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    CreateRoleUseCase? createRoleUseCase;
    GetRolesUseCase? getRolesUseCase;
    GetRoleByIdUseCase? getRoleByIdUseCase;
    UpdateRoleUseCase? updateRoleUseCase;
    ActivateRoleUseCase? activateRoleUseCase;
    DeactivateRoleUseCase? deactivateRoleUseCase;
    try {
      createRoleUseCase = sl<CreateRoleUseCase>();
      getRolesUseCase = sl<GetRolesUseCase>();
      getRoleByIdUseCase = sl<GetRoleByIdUseCase>();
      updateRoleUseCase = sl<UpdateRoleUseCase>();
      activateRoleUseCase = sl<ActivateRoleUseCase>();
      deactivateRoleUseCase = sl<DeactivateRoleUseCase>();
    } catch (_) {}

    return BlocProvider(
      create: (_) => RoleCubit(
        createRoleUseCase: createRoleUseCase,
        getRolesUseCase: getRolesUseCase,
        getRoleByIdUseCase: getRoleByIdUseCase,
        updateRoleUseCase: updateRoleUseCase,
        activateRoleUseCase: activateRoleUseCase,
        deactivateRoleUseCase: deactivateRoleUseCase,
      )..loadRoles(),
      child: RoleListView(
        showAppBar: showAppBar,
        leading: leading,
      ),
    );
  }
}

class RoleListView extends StatefulWidget {
  final bool showAppBar;
  final Widget? leading;

  const RoleListView({
    super.key,
    this.showAppBar = true,
    this.leading,
  });

  @override
  State<RoleListView> createState() => _RoleListViewState();
}

class _RoleListViewState extends State<RoleListView> {
  final FocusNode _keyboardFocusNode = FocusNode();

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  void _showCreateDialog(BuildContext context, {String? roleId}) {
    final cubit = context.read<RoleCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: RoleCreateDialog(roleId: roleId),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, String roleId) {
    final cubit = context.read<RoleCubit>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: RoleDetailDialog(roleId: roleId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: widget.showAppBar
          ? AppCustomAppbar(
              title: 'Role Master',
              leading: widget.leading,
              actions: [
                AppButton(
                  text: 'Create New Role',
                  icon: const Icon(Icons.add, size: 18),
                  onPressed: () => _showCreateDialog(context),
                ),
              ],
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: BlocConsumer<RoleCubit, RoleState>(
              listener: (context, state) {
                if (state is RoleError) {
                  showCustomSnackBar(
                    context: context,
                    message: state.message,
                    type: SnackBarType.failure,
                  );
                } else if (state is RoleOperationSuccess) {
                  showCustomSnackBar(
                    context: context,
                    message: state.message,
                    type: SnackBarType.success,
                  );
                } else if (state is RoleDetailError) {
                  showCustomSnackBar(
                    context: context,
                    message: state.message,
                    type: SnackBarType.failure,
                  );
                }
              },
              builder: (context, state) {
                final cubit = context.read<RoleCubit>();
                final lastData = cubit.lastData;

                if (state is RoleLoading && lastData == null) {
                  return const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                final String emptyMessage =
                    state is RoleError ? state.message : 'No roles found';

                if (lastData != null || state is RoleLoaded) {
                  final paginatedData = (state is RoleLoaded)
                      ? state.paginatedData
                      : lastData!;

                  return PaginatedListWrapper<RoleEntity>(
                    data: paginatedData,
                    currentSearchQuery: cubit.searchQuery,
                    searchFocusNode: _keyboardFocusNode,
                    onPageChange: (page) => cubit.loadRoles(page: page),
                    onItemsPerPageChange: (size) => cubit.loadRoles(size: size),
                    onSearchQueryChange: (query) =>
                        cubit.onSearchQueryChange(query),
                    emptyStateMessage: emptyMessage,
                    bodyBuilder: (context, data) {
                      if (data.items.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Center(
                            child: Text(
                              emptyMessage,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: data.items.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1, color: Color(0xFFE2E8F0)),
                        itemBuilder: (context, index) {
                          final role = data.items[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            title: Text(
                              role.name.isEmpty ? 'Unknown Role' : role.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            subtitle: Text(
                              role.description.isEmpty
                                  ? 'No description'
                                  : role.description,
                              style: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 13,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppStatusBadge(
                                  status: role.status,
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  tooltip: 'View Details',
                                  icon: const Icon(
                                    Icons.remove_red_eye_outlined,
                                    size: 20,
                                    color: AppColors.appThemeColorLight,
                                  ),
                                  onPressed: () =>
                                      _showDetailDialog(context, role.id),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 20,
                                    color: Color(0xFF64748B),
                                  ),
                                  onPressed: () => _showCreateDialog(
                                    context,
                                    roleId: role.id,
                                  ),
                                  tooltip: 'Edit',
                                  splashRadius: 20,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}
