import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:identity/core/design/theme/colors.dart';
import 'package:identity/core/design/widgets/app_button.dart';
import 'package:identity/core/design/widgets/app_text_form_field.dart';
import 'package:identity/core/shared/snackbar.dart';
import 'package:identity/features/user_view/domain/entities/user_entity.dart';
import '../../view_model/user_cubit.dart';
import '../../view_model/user_state.dart';

/// Password policy constants.
const int _kMinLength = 8;
final RegExp _kUppercase = RegExp(r'[A-Z]');
final RegExp _kLowercase = RegExp(r'[a-z]');
final RegExp _kDigit = RegExp(r'\d');
final RegExp _kSpecial = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');

class ResetPasswordDialog extends StatefulWidget {
  final UserEntity user;

  const ResetPasswordDialog({super.key, required this.user});

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showNew = false;
  bool _showConfirm = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ── Validation ─────────────────────────────────────────────────────────────

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) return 'New password is required.';
    if (value.length < _kMinLength) {
      return 'Password must be at least $_kMinLength characters.';
    }
    if (!_kUppercase.hasMatch(value)) {
      return 'Must contain at least one uppercase letter.';
    }
    if (!_kLowercase.hasMatch(value)) {
      return 'Must contain at least one lowercase letter.';
    }
    if (!_kDigit.hasMatch(value)) {
      return 'Must contain at least one digit.';
    }
    if (!_kSpecial.hasMatch(value)) {
      return 'Must contain at least one special character.';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your new password.';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match.';
    }
    return null;
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<UserCubit>().resetPassword(
      widget.user.id,
      _newPasswordController.text,
    );
  }

  // ── Password strength indicator ────────────────────────────────────────────

  double _strength(String pwd) {
    if (pwd.isEmpty) return 0;
    int score = 0;
    if (pwd.length >= _kMinLength) score++;
    if (_kUppercase.hasMatch(pwd)) score++;
    if (_kLowercase.hasMatch(pwd)) score++;
    if (_kDigit.hasMatch(pwd)) score++;
    if (_kSpecial.hasMatch(pwd)) score++;
    return score / 5;
  }

  Color _strengthColor(double s) {
    if (s < 0.4) return const Color(0xFFEF4444);
    if (s < 0.8) return const Color(0xFFF59E0B);
    return const Color(0xFF22C55E);
  }

  String _strengthLabel(double s) {
    if (s < 0.4) return 'Weak';
    if (s < 0.8) return 'Fair';
    return 'Strong';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserSuccess) {
          if (ModalRoute.of(context)?.isCurrent ?? false) {
            Navigator.of(context).pop();
          }
        } else if (state is UserError) {
          showCustomSnackBar(
            context: context,
            message: state.message,
            type: SnackBarType.failure,
          );
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ───────────────────────────────────────────────
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.appThemeColorLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.lock_reset_rounded,
                            color: AppColors.appThemeColorLight,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Reset Password',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.user.userName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, size: 20),
                          color: const Color(0xFF94A3B8),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 24),

                    // ── New Password ─────────────────────────────────────────
                    _SectionLabel(text: 'New Password'),
                    const SizedBox(height: 8),
                    AppTextFormField(
                      controller: _newPasswordController,
                      hintText: 'Enter new password',
                      obscureText: !_showNew,
                      validator: _validateNewPassword,
                      onChanged: (_) => setState(() {}),
                      suffix: _TogglePasswordIcon(
                        show: _showNew,
                        onTap: () => setState(() => _showNew = !_showNew),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ── Strength bar ─────────────────────────────────────────
                    _PasswordStrengthBar(
                      strength: _strength(_newPasswordController.text),
                      strengthColor: _strengthColor(
                        _strength(_newPasswordController.text),
                      ),
                      strengthLabel: _strengthLabel(
                        _strength(_newPasswordController.text),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Confirm Password ─────────────────────────────────────
                    _SectionLabel(text: 'Confirm New Password'),
                    const SizedBox(height: 8),
                    AppTextFormField(
                      controller: _confirmPasswordController,
                      hintText: 'Re-enter new password',
                      obscureText: !_showConfirm,
                      validator: _validateConfirmPassword,
                      suffix: _TogglePasswordIcon(
                        show: _showConfirm,
                        onTap: () =>
                            setState(() => _showConfirm = !_showConfirm),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ── Policy hints ─────────────────────────────────────────
                    _PolicyChecklist(password: _newPasswordController.text),
                    const SizedBox(height: 28),

                    // ── Actions ──────────────────────────────────────────────
                    BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        final isLoading = state is UserLoading;
                        return Row(
                          children: [
                            Expanded(
                              child: AppOutlinedButton(
                                text: 'Cancel',
                                onPressed: isLoading
                                    ? null
                                    : () => Navigator.of(context).pop(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AppButton(
                                text: isLoading
                                    ? 'Resetting...'
                                    : 'Reset Password',
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        _submit(context);
                                      },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Private sub-widgets ────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }
}

class _TogglePasswordIcon extends StatelessWidget {
  final bool show;
  final VoidCallback onTap;
  const _TogglePasswordIcon({required this.show, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        show ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        size: 18,
        color: const Color(0xFF94A3B8),
      ),
    );
  }
}

class _PasswordStrengthBar extends StatelessWidget {
  final double strength;
  final Color strengthColor;
  final String strengthLabel;

  const _PasswordStrengthBar({
    required this.strength,
    required this.strengthColor,
    required this.strengthLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (strength == 0) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Password strength',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            Text(
              strengthLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: strengthColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: strength,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
            minHeight: 5,
          ),
        ),
      ],
    );
  }
}

class _PolicyChecklist extends StatelessWidget {
  final String password;
  const _PolicyChecklist({required this.password});

  @override
  Widget build(BuildContext context) {
    final rules = [
      ('At least 8 characters', password.length >= _kMinLength),
      ('One uppercase letter', _kUppercase.hasMatch(password)),
      ('One lowercase letter', _kLowercase.hasMatch(password)),
      ('One digit', _kDigit.hasMatch(password)),
      ('One special character', _kSpecial.hasMatch(password)),
    ];
    return Column(
      children: rules.map((rule) {
        final met = rule.$2;
        return Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              Icon(
                met ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                size: 14,
                color: met ? const Color(0xFF22C55E) : const Color(0xFFCBD5E1),
              ),
              const SizedBox(width: 6),
              Text(
                rule.$1,
                style: TextStyle(
                  fontSize: 12,
                  color: met
                      ? const Color(0xFF16A34A)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
