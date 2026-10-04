import 'package:equatable/equatable.dart';
import 'package:identity/shared/component/pagination_component.dart';
import '../../domain/entities/role_entity.dart';

abstract class RoleState extends Equatable {
  const RoleState();

  @override
  List<Object?> get props => [];
}

class RoleInitial extends RoleState {}

class RoleLoading extends RoleState {}

class RoleLoaded extends RoleState {
  final PaginatedData<RoleEntity> paginatedData;

  const RoleLoaded(this.paginatedData);

  @override
  List<Object?> get props => [paginatedData];
}

class RoleOperationSuccess extends RoleState {
  final String message;

  const RoleOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class RoleError extends RoleState {
  final String message;

  const RoleError(this.message);

  @override
  List<Object?> get props => [message];
}

class RoleDetailLoading extends RoleState {}

class RoleDetailLoaded extends RoleState {
  final RoleEntity role;

  const RoleDetailLoaded(this.role);

  @override
  List<Object?> get props => [role];
}

class RoleDetailError extends RoleState {
  final String message;

  const RoleDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
