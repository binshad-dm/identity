import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class CreateUserState extends Equatable {
  const CreateUserState();

  @override
  List<Object?> get props => [];
}

class CreateUserInitial extends CreateUserState {}

class CreateUserLoading extends CreateUserState {}

class CreateUserSuccess extends CreateUserState {
  final UserEntity user;
  final String message;

  const CreateUserSuccess({required this.user, required this.message});

  @override
  List<Object?> get props => [user, message];
}

class CreateUserError extends CreateUserState {
  final String message;

  const CreateUserError(this.message);

  @override
  List<Object?> get props => [message];
}
