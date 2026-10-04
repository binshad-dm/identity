import 'package:equatable/equatable.dart';
import 'package:identity/core/network/models/paginated_response.dart';
import 'package:identity/features/user_view/domain/entities/user_detail_entity.dart';
import 'user_entity.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final PaginatedResponse<UserEntity> response;
  final Set<String> selectedUserIds;

  const UserLoaded(this.response, {this.selectedUserIds = const {}});

  @override
  List<Object?> get props => [response, selectedUserIds];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

class UserSuccess extends UserState {
  final String message;

  const UserSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UserDetailLoading extends UserState {}

class UserDetailLoaded extends UserState {
  final UserDetailEntity detail;

  const UserDetailLoaded(this.detail);

  @override
  List<Object?> get props => [detail];
}

/// Emitted when the requested user ID returns 404 (account deleted / unavailable).
class UserDetailNotFound extends UserState {
  const UserDetailNotFound();
}

/// Emitted while the change-password API call is in flight.
class PasswordChanging extends UserState {}

/// Emitted when the password has been changed successfully.
class PasswordChanged extends UserState {
  const PasswordChanged();
}
