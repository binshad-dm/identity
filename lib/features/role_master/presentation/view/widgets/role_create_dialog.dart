import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:identity/core/design/widgets/app_button.dart';
import 'package:identity/core/design/widgets/app_status_badge.dart';
import 'package:identity/core/design/widgets/app_text_form_field.dart';
import 'package:identity/features/role_master/domain/entities/create_role_request.dart';

import '../../view_model/role_cubit.dart';
import '../../view_model/role_state.dart';

class RoleCreateDialog extends StatefulWidget {
  final String? roleId;
  const RoleCreateDialog({super.key, this.roleId});

  @override
  State<RoleCreateDialog> createState() => _RoleCreateDialogState();
}

class _RoleCreateDialogState extends State<RoleCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isActive = true;
  bool? _originalIsActive;
  bool _isToggleLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.roleId != null) {
      context.read<RoleCubit>().getRoleById(widget.roleId!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _toggleStatus(bool value) async {
    if (_isToggleLoading || widget.roleId == null) return;

    final previousValue = _isActive;
    setState(() {
      _isActive = value;
      _isToggleLoading = true;
    });

    final success = await context.read<RoleCubit>().toggleRoleStatus(
      widget.roleId!,
      value,
    );

    if (mounted) {
      setState(() {
        _isToggleLoading = false;
        if (!success) {
          _isActive = previousValue; // Revert
        } else {
          _originalIsActive = value;
        }
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final request = CreateRoleRequest(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
      );
      if (widget.roleId != null) {
        context.read<RoleCubit>().updateRole(widget.roleId!, request);
      } else {
        context.read<RoleCubit>().createRole(request);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RoleCubit, RoleState>(
      listener: (context, state) {
        if (state is RoleOperationSuccess) {
          Navigator.of(context).pop();
        }
        if (state is RoleDetailLoaded) {
          _nameController.text = state.role.name;
          _descriptionController.text = state.role.description;
          setState(() {
            _originalIsActive = state.role.status == 'ACTIVE';
            _isActive = _originalIsActive!;
          });
        }
      },
      builder: (context, state) {
        final isLoadingDetails = state is RoleDetailLoading;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(24),
            child: isLoadingDetails
                ? const SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<RoleCubit, RoleState>(
                          builder: (context, state) {
                            final isLoading = state is RoleLoading;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.roleId != null
                                      ? 'Edit Role'
                                      : 'Create Role',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: isLoading
                                      ? null
                                      : () => Navigator.of(context).pop(),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        AppTextFormField(
                          controller: _nameController,
                          label: 'Role Name',
                          required: true,
                          hintText: 'Enter role name',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a role name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AppTextFormField(
                          controller: _descriptionController,
                          label: 'Role Description',
                          required: true,
                          hintText: 'Enter role description',
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        if (widget.roleId != null) ...[
                          const SizedBox(height: 16),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppStatusBadge(
                                status: _isActive ? 'ACTIVE' : 'INACTIVE',
                              ),
                              const SizedBox(width: 8),
                              _isToggleLoading
                                  ? const SizedBox(
                                      width: 50,
                                      height: 36,
                                      child: Center(
                                        child: SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Switch(
                                      value: _isActive,
                                      onChanged: _isToggleLoading
                                          ? null
                                          : _toggleStatus,
                                      activeThumbColor: const Color(0xFF16A34A),
                                      activeTrackColor: const Color(0xFFDCFCE7),
                                    ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 24),
                        BlocBuilder<RoleCubit, RoleState>(
                          builder: (context, state) {
                            final isLoading = state is RoleLoading;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: isLoading
                                      ? null
                                      : () => Navigator.of(context).pop(),
                                  icon: const Icon(Icons.close, size: 18),
                                  label: const Text('Cancel'),
                                ),
                                const SizedBox(width: 16),
                                AppButton(
                                  text: widget.roleId != null
                                      ? 'Update'
                                      : 'Save',
                                  enabled: !isLoading,
                                  icon: isLoading
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Icons.save, size: 18),
                                  onPressed: isLoading ? null : _submit,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
