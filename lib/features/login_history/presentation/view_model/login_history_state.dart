import 'package:equatable/equatable.dart';
import '../../../../core/network/models/paginated_response.dart';
import '../../domain/entities/login_history_entity.dart';

abstract class LoginHistoryState extends Equatable {
  const LoginHistoryState();

  @override
  List<Object?> get props => [];
}

class LoginHistoryInitial extends LoginHistoryState {}

class LoginHistoryLoading extends LoginHistoryState {}

class LoginHistoryLoaded extends LoginHistoryState {
  final PaginatedResponse<LoginHistoryEntity> response;

  const LoginHistoryLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class LoginHistoryError extends LoginHistoryState {
  final String message;

  const LoginHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
