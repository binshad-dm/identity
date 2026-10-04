import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:identity/core/shared/snackbar.dart';
import '../../domain/entities/create_user_request.dart';
import '../../domain/entities/update_user_request.dart';
import '../../domain/entities/user_entity.dart';
import '../view_model/create_user_cubit.dart';
import '../view_model/create_user_state.dart';
import 'create_user_actions.dart';
import 'user_information_section.dart';

class CreateUserForm extends StatefulWidget {
  final UserEntity? userToEdit;

  const CreateUserForm({super.key, this.userToEdit});

  @override
  State<CreateUserForm> createState() => _CreateUserFormState();
}

class _CreateUserFormState extends State<CreateUserForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  /// Only used in Create mode — null when editing an existing user.
  late final TextEditingController? _passwordController;

  bool get _isUpdateMode => widget.userToEdit != null;

  @override
  void initState() {
    super.initState();

    // Password controller only exists in Create mode
    _passwordController = _isUpdateMode ? null : TextEditingController();

    // Pre-populate fields when editing an existing user
    final user = widget.userToEdit;
    if (user != null) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _usernameController.text = user.userName;
      _emailController.text = user.email;
      _phoneController.text =
          user.phoneNumber; // phoneNumber is now part of UserEntity
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController?.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final user = widget.userToEdit;
    if (user != null) {
      // ── Update flow ──────────────────────────────────────────────────────────
      final request = UpdateUserRequest(
        id: user.id,
        userName: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );
      context.read<CreateUserCubit>().updateUser(request);
    } else {
      // ── Create flow ──────────────────────────────────────────────────────────
      final request = CreateUserRequest(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        userName: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController?.text.trim() ?? '',
      );
      context.read<CreateUserCubit>().createUser(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateUserCubit, CreateUserState>(
      listener: (context, state) {
        if (state is CreateUserSuccess) {
          showCustomSnackBar(
            context: context,
            message: state.message,
            type: SnackBarType.success,
          );
          Get.back();
        } else if (state is CreateUserError) {
          showCustomSnackBar(
            context: context,
            message: state.message,
            type: SnackBarType.failure,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateUserLoading;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInformationSection(
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                usernameController: _usernameController,
                emailController: _emailController,
                phoneController: _phoneController,
                // Passing null hides the Password field in Update mode
                passwordController: _passwordController,
              ),
              const SizedBox(height: 48),
              CreateUserActions(
                isLoading: isLoading,
                isUpdate: _isUpdateMode,
                onCancel: () => Get.back(),
                onCreate: _handleSubmit,
              ),
            ],
          ),
        );
      },
    );
  }
}
