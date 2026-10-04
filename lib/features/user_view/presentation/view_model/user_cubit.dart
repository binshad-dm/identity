import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:identity/core/error/failure.dart';
import 'package:identity/core/network/models/paginated_response.dart';
import 'package:identity/features/user_view/domain/entities/user_entity.dart';
import 'package:identity/features/user_view/domain/usecases/fetch_users_use_case.dart';
import 'package:identity/features/user_view/domain/usecases/get_user_detail_use_case.dart';
import 'package:identity/features/user_view/domain/repositories/user_repository.dart';
import 'package:identity/features/user_view/domain/usecases/change_password_use_case.dart';
import 'package:identity/features/user_view/domain/entities/role_select_item.dart';
import 'user_state.dart';
import 'user_entity.dart';

class UserCubit extends Cubit<UserState> {
  final FetchUsersUseCase? fetchUsersUseCase;
  final GetUserDetailUseCase? getUserDetailUseCase;
  final ChangePasswordUseCase? changePasswordUseCase;
  final UserRepository? userRepository;

  UserCubit({
    this.fetchUsersUseCase,
    this.getUserDetailUseCase,
    this.changePasswordUseCase,
    this.userRepository,
  }) : super(UserInitial());

  final Set<String> _selectedUserIds = {};
  Set<String> get selectedUserIds => _selectedUserIds;
  int get selectedCount => _selectedUserIds.length;

  Timer? _debouncer;
  int _page = 1;
  int _pageSize = 10;
  PaginatedResponse<UserEntity>? lastResponse;
  String searchQuery = '';
  String? lastDetailId; // tracks the last requested detail ID for retry

  int get currentPage => _page;
  int get pageSize => _pageSize;

  // ──────────────────────────────────────────────
  // 3 realistic mock users matching the API schema
  // ──────────────────────────────────────────────
  static final List<UserEntity> _mockUsers = [
    const UserEntity(
      id: '3fa85f64-5717-4562-b3fc-2c963f66afa6',
      userName: 'john_doe',
      email: 'john.doe@example.com',
      firstName: 'John',
      lastName: 'Doe',
      status: 'ACTIVE',
      roles: ['USER'],
    ),
    const UserEntity(
      id: '9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d',
      userName: 'jane_admin',
      email: 'jane.admin@example.com',
      firstName: 'Jane',
      lastName: 'Smith',
      status: 'ACTIVE',
      roles: ['ADMIN', 'USER'],
    ),
    const UserEntity(
      id: 'a7c3d1e2-8f4b-4d9c-b1e6-3a5c7f2e9d4b',
      userName: 'dr_patel',
      email: 'dr.patel@clinic.com',
      firstName: 'Raj',
      lastName: 'Patel',
      status: 'INACTIVE',
      roles: ['DOCTOR', 'USER'],
    ),
  ];

  Future<void> loadUsers({String? search, int? page, int? size}) async {
    if (search != null) searchQuery = search;
    if (page != null) _page = page;
    if (size != null) {
      _pageSize = size;
      _page = 1;
    }

    emit(UserLoading());

    // Use real use case if injected, otherwise fall back to mock data
    if (fetchUsersUseCase != null) {
      final result = await fetchUsersUseCase!.call(
        search: searchQuery.isNotEmpty ? searchQuery : null,
        page: _page,
        size: _pageSize,
      );

      result.fold((failure) => emit(UserError(failure.message)), (response) {
        lastResponse = response;
        emit(UserLoaded(response, selectedUserIds: Set.from(_selectedUserIds)));
      });
    } else {
      // Mock fallback — filter by search query for demonstration
      await Future.delayed(const Duration(milliseconds: 400));

      final filtered = searchQuery.isEmpty
          ? _mockUsers
          : _mockUsers.where((u) {
              final q = searchQuery.toLowerCase();
              return u.fullName.toLowerCase().contains(q) ||
                  u.email.toLowerCase().contains(q) ||
                  u.userName.toLowerCase().contains(q);
            }).toList();

      final response = PaginatedResponse<UserEntity>(
        content: filtered,
        totalPages: 1,
        totalElements: filtered.length,
        size: _pageSize,
        number: _page,
      );

      lastResponse = response;
      emit(UserLoaded(response, selectedUserIds: Set.from(_selectedUserIds)));
    }
  }

  Future<void> fetchUserDetail(String id) async {
    lastDetailId = id;
    emit(UserDetailLoading());

    if (getUserDetailUseCase != null) {
      final result = await getUserDetailUseCase!.call(id);
      result.fold((failure) {
        if (failure is NotFoundFailure) {
          emit(const UserDetailNotFound());
        } else {
          emit(UserError(failure.message));
        }
      }, (detail) => emit(UserDetailLoaded(detail)));
    } else {
      // Mock fallback for detail
      await Future.delayed(const Duration(milliseconds: 300));
      // find from mock list
      final found = _mockUsers.where((u) => u.id == id).toList();
      if (found.isNotEmpty) {
        final u = found.first;
        emit(
          UserDetailLoaded(
            // We emit a minimal detail using available fields
            // In real flow, the API fills all fields
            _buildMockDetail(u),
          ),
        );
      } else {
        emit(const UserError('User not found.'));
      }
    }
  }

  // ignore: unused_element
  Never _buildMockDetail(UserEntity u) {
    // Inline to avoid importing UserDetailEntity in cubit directly –
    // return via domain layer
    throw UnimplementedError('Should not be called without real use case');
  }

  void onSearchQueryChange(String query) {
    searchQuery = query;
    _debouncer?.cancel();
    _debouncer = Timer(
      const Duration(milliseconds: 500),
      () => loadUsers(page: 1),
    );
  }

  void toggleSelection(UserEntity user) {
    final id = user.id;
    if (_selectedUserIds.contains(id)) {
      _selectedUserIds.remove(id);
    } else {
      _selectedUserIds.add(id);
    }
    final current = state;
    if (current is UserLoaded) {
      emit(
        UserLoaded(
          current.response,
          selectedUserIds: Set.from(_selectedUserIds),
        ),
      );
    }
  }

  void clearSelection() {
    _selectedUserIds.clear();
    final current = state;
    if (current is UserLoaded) {
      emit(UserLoaded(current.response, selectedUserIds: const {}));
    }
  }

  Future<void> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    if (changePasswordUseCase == null) {
      emit(const UserError('Change password feature is not available.'));
      return;
    }
    emit(PasswordChanging());
    final result = await changePasswordUseCase!.call(
      userId: userId,
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
    result.fold(
      (failure) => emit(UserError(failure.message)),
      (_) => emit(const PasswordChanged()),
    );
  }

  Future<void> resetPassword(String id, String newPassword) async {
    if (userRepository == null) return;
    emit(UserLoading());
    final result = await userRepository!.resetPassword(id, newPassword);
    result.fold((failure) => emit(UserError(failure.message)), (_) {
      emit(const UserSuccess('Password reset successfully.'));
      loadUsers(page: _page); // Reload current page
    });
  }

  Future<void> activateUser(String id) async {
    debugPrint(
      'DEBUG [UserCubit]: activateUser called, userRepository is ${userRepository == null ? 'NULL' : 'NOT NULL'}',
    );
    if (userRepository == null) return;
    emit(UserLoading());
    final result = await userRepository!.activateUser(id);
    result.fold((failure) => emit(UserError(failure.message)), (_) {
      emit(const UserSuccess('User activated successfully.'));
      loadUsers(page: _page); // Reload current page
    });
  }

  Future<void> deactivateUser(String id) async {
    debugPrint(
      'DEBUG [UserCubit]: deactivateUser called, userRepository is ${userRepository == null ? 'NULL' : 'NOT NULL'}',
    );
    if (userRepository == null) return;
    emit(UserLoading());
    final result = await userRepository!.deactivateUser(id);
    result.fold((failure) => emit(UserError(failure.message)), (_) {
      emit(const UserSuccess('User deactivated successfully.'));
      loadUsers(page: _page); // Reload current page
    });
  }

  Future<List<RoleSelectItem>> fetchRolesSelect() async {
    debugPrint('DEBUG [UserCubit]: fetchRolesSelect called');
    if (userRepository != null) {
      final result = await userRepository!.getRolesSelect();
      return result.fold((failure) {
        debugPrint(
          'DEBUG [UserCubit]: fetchRolesSelect failed: ${failure.message}',
        );
        return [];
      }, (roles) => roles);
    } else {
      // Fallback for mock mode
      await Future.delayed(const Duration(milliseconds: 300));
      return const [
        RoleSelectItem(
          id: '3fa85f64-5717-4562-b3fc-2c963f66afa6',
          name: 'ADMIN',
        ),
        RoleSelectItem(
          id: '3fa85f64-5717-4562-b3fc-2c963f66afa7',
          name: 'USER',
        ),
        RoleSelectItem(
          id: '3fa85f64-5717-4562-b3fc-2c963f66afa8',
          name: 'DOCTOR',
        ),
      ];
    }
  }

  Future<void> updateUserRoles(String id, List<String> roles) async {
    debugPrint(
      'DEBUG [UserCubit]: updateUserRoles called for $id with roles $roles',
    );
    // Ensure roles cannot be duplicated
    final uniqueRoles = roles.toSet().toList();

    if (userRepository == null) {
      emit(UserLoading());
      await Future.delayed(const Duration(milliseconds: 400));
      emit(const UserSuccess('User roles updated successfully.'));
      loadUsers(page: _page);
      return;
    }

    emit(UserLoading());
    final result = await userRepository!.updateUserRoles(id, uniqueRoles);
    result.fold((failure) => emit(UserError(failure.message)), (_) {
      emit(const UserSuccess('User roles updated successfully.'));
      loadUsers(page: _page);
    });
  }

  @override
  Future<void> close() {
    _debouncer?.cancel();
    return super.close();
  }
}
