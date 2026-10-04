import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:identity/features/user_view/domain/entities/user_entity.dart';
import 'package:identity/features/user_view/presentation/view/create_user_page.dart';
import 'package:identity/core/design/widgets/app_appbar.dart';
import 'package:identity/core/design/widgets/app_button.dart';
import 'package:identity/core/shared/snackbar.dart';
import 'package:identity/core/utils/wrappers/escape_pop_wrapper_v2.dart';
import 'package:identity/shared/component/pagination_component.dart';
import 'package:identity/core/service_locator.dart';
import 'package:identity/features/user_view/domain/usecases/fetch_users_use_case.dart';
import 'package:identity/features/user_view/domain/usecases/get_user_detail_use_case.dart';
import 'package:identity/features/user_view/domain/usecases/change_password_use_case.dart';
import 'package:identity/features/user_view/domain/repositories/user_repository.dart';
import '../../../../core/config/identity_config.dart';
import '../../../../core/identity_admin.dart';
import '../view_model/user_cubit.dart';
import '../view_model/user_state.dart';
import '../view_model/user_entity.dart';
import 'widgets/user_table.dart';
import 'widgets/user_detail_dialog.dart';
import 'widgets/change_password_dialog.dart';
import 'widgets/reset_password_dialog.dart';
import 'widgets/role_management_dialog.dart';
import '../semantics/user_view_semantics.dart';

class UserListPage extends StatelessWidget {
  final bool showAppBar;
  final IdentityUser? currentUser;
  final Widget? leading;

  const UserListPage({
    super.key,
    this.showAppBar = true,
    this.currentUser,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    FetchUsersUseCase? fetchUseCase;
    GetUserDetailUseCase? detailUseCase;
    ChangePasswordUseCase? changePasswordUseCase;
    UserRepository? userRepository;

    try {
      fetchUseCase = sl<FetchUsersUseCase>();
    } catch (_) {}
    try {
      detailUseCase = sl<GetUserDetailUseCase>();
    } catch (_) {}
    try {
      changePasswordUseCase = sl<ChangePasswordUseCase>();
    } catch (_) {}
    try {
      userRepository = sl<UserRepository>();
      debugPrint(
        'DEBUG [UserListPage]: sl<UserRepository> resolved successfully.',
      );
    } catch (e) {
      debugPrint(
        'DEBUG [UserListPage]: sl<UserRepository> failed to resolve: $e',
      );
    }

    return BlocProvider(
      create: (_) => UserCubit(
        fetchUsersUseCase: fetchUseCase,
        getUserDetailUseCase: detailUseCase,
        changePasswordUseCase: changePasswordUseCase,
        userRepository: userRepository,
      )..loadUsers(),
      child: UserListView(
        showAppBar: showAppBar,
        currentUser: currentUser,
        leading: leading,
      ),
    );
  }
}

class UserListView extends StatefulWidget {
  final bool showAppBar;
  final IdentityUser? currentUser;
  final Widget? leading;

  const UserListView({
    super.key,
    this.showAppBar = true,
    this.currentUser,
    this.leading,
  });

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  static const Color bgColor = Color(0xFFF8FAFC);
  final FocusNode keyboardFocusNode = FocusNode();

  @override
  void dispose() {
    keyboardFocusNode.dispose();
    super.dispose();
  }

  // ── Detail dialog ──────────────────────────────────────────────────────────
  void _showUserDetailDialog(BuildContext context, UserEntity user) {
    final cubit = context.read<UserCubit>();
    // Kick off the API call before showing the dialog so the spinner
    // appears immediately while the request is in flight.
    cubit.fetchUserDetail(user.id);
    showDialog(
      context: context,
      builder: (dialogContext) =>
          BlocProvider.value(value: cubit, child: const UserDetailDialog()),
    );
  }

  // ── Register / edit ──────────────────────────────────────────────────────────────────
  void _navigateToEdit(BuildContext context, {UserEntity? user}) async {
    if (user == null) {
      // Create mode — open directly
      Get.to(() => const CreateUserPage())?.then((_) {
        if (context.mounted) context.read<UserCubit>().loadUsers();
      });
      return;
    }

    // Fetch the full user detail so the edit form has all fields (e.g. phoneNumber).
    // The list endpoint only returns a subset of fields.
    final cubit = context.read<UserCubit>();
    await cubit.fetchUserDetail(user.id);

    if (!context.mounted) return;

    final state = cubit.state;
    if (state is UserDetailLoaded) {
      final detail = state.detail;
      // Build a UserEntity from the full detail response, carrying all fields
      // (especially phoneNumber) into the edit form.
      final fullUser = UserEntity(
        id: detail.id,
        userName: detail.userName,
        email: detail.email,
        firstName: detail.firstName,
        lastName: detail.lastName,
        phoneNumber: detail.phoneNumber,
        status: detail.status,
        roles: detail.roles,
      );
      Get.to(() => CreateUserPage(userToEdit: fullUser))?.then((_) {
        if (context.mounted) cubit.loadUsers();
      });
    } else {
      // Detail fetch failed — fall back to list data (phoneNumber will be blank)
      Get.to(() => CreateUserPage(userToEdit: user))?.then((_) {
        if (context.mounted) cubit.loadUsers();
      });
    }
  }

  // ── Delete confirmation ────────────────────────────────────────────────────
  void _showDeleteConfirmation(BuildContext context, UserEntity user) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.userName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // context.read<UserCubit>().deleteUser(user.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context, UserEntity user) {
    debugPrint('DEBUG: _showResetPasswordDialog called for ${user.userName}');
    final cubit = context.read<UserCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: ResetPasswordDialog(user: user),
      ),
    );
  }

  void _showRoleManagementDialog(BuildContext context, UserEntity user) {
    debugPrint('DEBUG: _showRoleManagementDialog called for ${user.userName}');
    final cubit = context.read<UserCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: RoleManagementDialog(user: user),
      ),
    );
  }

  void _toggleUserStatus(BuildContext context, UserEntity user) {
    debugPrint('DEBUG: _toggleUserStatus called for ${user.userName}');
    final cubit = context.read<UserCubit>();
    if (user.status == 'ACTIVE') {
      debugPrint('DEBUG: Calling deactivateUser on cubit');
      cubit.deactivateUser(user.id);
    } else {
      debugPrint('DEBUG: Calling activateUser on cubit');
      cubit.activateUser(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeUser = widget.currentUser ?? IdentityAdmin.config?.currentUser;

    return EscapePoppableWrapperV2(
      onPop: () async {
        final navigator = Navigator.of(context);
        if (navigator.canPop()) {
          navigator.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: widget.showAppBar
            ? AppCustomAppbar(
                title: "User Master",
                leading: widget.leading,
                actions: [
                  if (activeUser != null) ...[
                    Semantics(
                      label: 'Change Password Button',
                      button: true,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                          ),
                        ),
                        onPressed: () {
                          final cubit = context.read<UserCubit>();
                          showDialog(
                            context: context,
                            builder: (dialogContext) => BlocProvider.value(
                              value: cubit,
                              child: ChangePasswordDialog(
                                userId: activeUser.id,
                                userDisplayName: activeUser.userName,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.lock_reset_rounded, size: 20),
                        label: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Change Password',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Semantics(
                    label: UserViewSemantics.registerButton,
                    identifier: UserViewSemantics.registerButton,
                    button: true,
                    child: AppButton(
                      text: 'Register User',
                      icon: const Icon(Icons.add, size: 18),
                      onPressed: () => _navigateToEdit(context),
                    ),
                  ),
                ],
              )
            : null,
        backgroundColor: bgColor,
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
              child: _buildTableBody(context),
            ),
          ),
        ),
      ));
    
  }

  Widget _buildTableBody(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserError) {
          showCustomSnackBar(
            context: context,
            message: state.message,
            type: SnackBarType.failure,
          );
        } else if (state is UserSuccess) {
          showCustomSnackBar(
            context: context,
            message: state.message,
            type: SnackBarType.success,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<UserCubit>();
        final lastResponse = cubit.lastResponse;

        // Show full-screen spinner only on first load (no cached data yet).
        if (state is UserLoading && lastResponse == null) {
          return const Padding(
            padding: EdgeInsets.all(40.0),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        if (lastResponse != null || state is UserLoaded) {
          final users = (state is UserLoaded) ? state.response : lastResponse!;

          return PaginatedListWrapper<UserEntity>(
            data: PaginatedData<UserEntity>(
              items: users.content,
              totalItems: users.totalElements,
              currentPage: cubit.currentPage,
              totalPages: users.totalPages,
              itemsPerPage: cubit.pageSize,
            ),
            currentSearchQuery: cubit.searchQuery,
            searchFocusNode: keyboardFocusNode,
            onPageChange: (page) => cubit.loadUsers(page: page),
            onItemsPerPageChange: (size) => cubit.loadUsers(size: size),
            onSearchQueryChange: (query) => cubit.onSearchQueryChange(query),
            bodyBuilder: (context, data) {
              if (data.items.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Semantics(
                    label: UserViewSemantics.emptyState,
                    child: const Center(child: Text('No users found.')),
                  ),
                );
              }
              return Semantics(
                label: UserViewSemantics.userList,
                child: UserTable(
                  onResetPassword: (user) =>
                      _showResetPasswordDialog(context, user),
                  onRoleManagement: (user) =>
                      _showRoleManagementDialog(context, user),
                  users: data.items,
                  startIndex: (cubit.currentPage - 1) * cubit.pageSize,
                  selectedIds: cubit.selectedUserIds,
                  onViewDetail: (user) => _showUserDetailDialog(context, user),
                  onEdit: (user) => _navigateToEdit(context, user: user),
                  onDelete: (user) => _showDeleteConfirmation(context, user),
                  onToggleSelection: (user) => cubit.toggleSelection(user),
                  onToggleStatus: (user) => _toggleUserStatus(context, user),
                  onSelectAll: () {},
                  onClearSelection: () => cubit.clearSelection(),
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
