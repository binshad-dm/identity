import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:identity/core/design/widgets/app_appbar.dart';
import 'package:identity/core/service_locator.dart';
import 'package:identity/features/user_view/domain/entities/user_entity.dart';
import 'package:identity/features/user_view/domain/usecases/create_user_use_case.dart';
import '../../domain/usecases/update_user_use_case.dart';
import '../view_model/create_user_cubit.dart';
import '../widgets/create_user_form.dart';

class CreateUserPage extends StatelessWidget {
  final UserEntity? userToEdit;

  const CreateUserPage({super.key, this.userToEdit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateUserCubit(
        createUserUseCase: sl<CreateUserUseCase>(),
        updateUserUseCase: sl<UpdateUserUseCase>(),
      ),
      child: Scaffold(
        appBar: AppCustomAppbar(
          title: userToEdit != null ? 'Update User' : 'Create User',
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: CreateUserForm(userToEdit: userToEdit),
            ),
          ),
        ),
      ),
    );
  }
}
