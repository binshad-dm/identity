import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_user_use_case.dart';
import '../../domain/usecases/update_user_use_case.dart';
import '../../domain/entities/create_user_request.dart';
import '../../domain/entities/update_user_request.dart';
import 'create_user_state.dart';

class CreateUserCubit extends Cubit<CreateUserState> {
  final CreateUserUseCase createUserUseCase;
  final UpdateUserUseCase updateUserUseCase;

  CreateUserCubit({
    required this.createUserUseCase,
    required this.updateUserUseCase,
  }) : super(CreateUserInitial());

  Future<void> createUser(CreateUserRequest request) async {
    emit(CreateUserLoading());
    final result = await createUserUseCase(request);
    result.fold(
      (failure) => emit(CreateUserError(failure.message)),
      (user) => emit(CreateUserSuccess(user: user, message: 'User created successfully')),
    );
  }

  Future<void> updateUser(UpdateUserRequest request) async {
    emit(CreateUserLoading());
    final result = await updateUserUseCase(request);
    result.fold(
      (failure) => emit(CreateUserError(failure.message)),
      (user) => emit(CreateUserSuccess(user: user, message: 'User updated successfully')),
    );
  }
}
