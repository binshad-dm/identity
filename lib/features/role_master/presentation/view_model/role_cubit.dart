import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:identity/shared/component/pagination_component.dart';
import '../../domain/entities/create_role_request.dart';
import '../../domain/usecases/create_role_use_case.dart';
import '../../domain/usecases/get_roles_usecase.dart';
import '../../domain/usecases/get_role_by_id_usecase.dart';
import '../../domain/usecases/update_role_use_case.dart';
import '../../domain/usecases/activate_role_use_case.dart';
import '../../domain/usecases/deactivate_role_use_case.dart';
import '../../domain/entities/role_entity.dart';
import 'role_state.dart';

class RoleCubit extends Cubit<RoleState> {
  final CreateRoleUseCase? createRoleUseCase;
  final GetRolesUseCase? getRolesUseCase;
  final GetRoleByIdUseCase? getRoleByIdUseCase;
  final UpdateRoleUseCase? updateRoleUseCase;
  final ActivateRoleUseCase? activateRoleUseCase;
  final DeactivateRoleUseCase? deactivateRoleUseCase;

  int _currentPage = 1;
  int _itemsPerPage = 10;
  String _searchQuery = '';
  PaginatedData<RoleEntity>? lastData;

  String get searchQuery => _searchQuery;

  RoleCubit({
    this.createRoleUseCase,
    this.getRolesUseCase,
    this.getRoleByIdUseCase,
    this.updateRoleUseCase,
    this.activateRoleUseCase,
    this.deactivateRoleUseCase,
  }) : super(RoleInitial());

  Future<void> loadRoles({
    int? page,
    int? size,
    String? search,
    bool isSilent = false,
  }) async {
    _currentPage = page ?? _currentPage;
    _itemsPerPage = size ?? _itemsPerPage;
    _searchQuery = search ?? _searchQuery;

    if (getRolesUseCase == null) {
      emit(const RoleError('GetRolesUseCase not provided'));
      return;
    }

    if (!isSilent) {
      emit(RoleLoading());
    }
    final result = await getRolesUseCase!.call(
      page: _currentPage,
      size: _itemsPerPage,
      search: _searchQuery,
      status: null, // You can add status filtering later if needed
    );

    result.fold((failure) => emit(RoleError(failure.message)), (response) {
      lastData = PaginatedData<RoleEntity>(
        items: response.content,
        totalItems: response.totalElements,
        currentPage: _currentPage,
        totalPages: response.totalPages,
        itemsPerPage: _itemsPerPage,
      );
      emit(RoleLoaded(lastData!));
    });
  }

  void onSearchQueryChange(String query) {
    if (_searchQuery != query) {
      loadRoles(search: query, page: 1);
    }
  }

  Future<void> createRole(CreateRoleRequest request) async {
    if (createRoleUseCase == null) {
      emit(const RoleError('CreateRoleUseCase not provided'));
      return;
    }

    emit(RoleLoading());
    final result = await createRoleUseCase!.call(request);

    result.fold((failure) => emit(RoleError(failure.message)), (role) {
      emit(const RoleOperationSuccess('Role created successfully'));
      loadRoles(); // Reload the list after successful creation
    });
  }

  Future<void> getRoleById(String id) async {
    if (getRoleByIdUseCase == null) {
      emit(const RoleDetailError('GetRoleByIdUseCase not provided'));
      return;
    }

    emit(RoleDetailLoading());
    final result = await getRoleByIdUseCase!.call(id);

    result.fold(
      (failure) => emit(RoleDetailError(failure.message)),
      (role) => emit(RoleDetailLoaded(role)),
    );
  }

  Future<void> updateRole(String id, CreateRoleRequest request) async {
    if (updateRoleUseCase == null) {
      emit(const RoleError('UpdateRoleUseCase not provided'));
      return;
    }

    emit(RoleLoading());
    final result = await updateRoleUseCase!.call(id, request);

    result.fold((failure) => emit(RoleError(failure.message)), (role) {
      emit(const RoleOperationSuccess('Role updated successfully'));
      loadRoles(); // Reload the list after successful update
    });
  }

  Future<bool> toggleRoleStatus(String id, bool isActive) async {
    if (isActive && activateRoleUseCase == null) return false;
    if (!isActive && deactivateRoleUseCase == null) return false;

    final result = isActive
        ? await activateRoleUseCase!.call(id)
        : await deactivateRoleUseCase!.call(id);

    return result.fold(
      (failure) {
        emit(RoleError(failure.message));
        return false;
      },
      (_) {
        loadRoles(isSilent: true); // Reload the list silently
        return true;
      },
    );
  }
}
