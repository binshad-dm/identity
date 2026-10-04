import 'package:flutter/material.dart';
import 'package:identity/core/design/widgets/app_text_form_field.dart';
import 'package:gap/gap.dart';

class UserInformationSection extends StatefulWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  /// When null, the Password field is hidden (i.e. Update mode).
  final TextEditingController? passwordController;

  const UserInformationSection({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.usernameController,
    required this.emailController,
    required this.phoneController,
    this.passwordController,
  });

  @override
  State<UserInformationSection> createState() => _UserInformationSectionState();
}

class _UserInformationSectionState extends State<UserInformationSection> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User Information',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Gap(16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 600;
            final halfWidth = isDesktop
                ? (constraints.maxWidth / 2) - 8
                : constraints.maxWidth;

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: halfWidth,
                  child: AppTextFormField(
                    controller: widget.firstNameController,
                    label: 'First Name',
                    required: true,
                    hintText: 'Enter first name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'First name is required';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: halfWidth,
                  child: AppTextFormField(
                    controller: widget.lastNameController,
                    label: 'Last Name',
                    required: true,
                    hintText: 'Enter last name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Last name is required';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: halfWidth,
                  child: AppTextFormField(
                    controller: widget.usernameController,
                    label: 'Username',
                    required: true,
                    hintText: 'Enter username (no spaces)',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Username is required';
                      }
                      if (value.contains(' ')) {
                        return 'Username must not contain spaces';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: halfWidth,
                  child: AppTextFormField(
                    controller: widget.emailController,
                    label: 'Email',
                    required: true,
                    hintText: 'Enter email address',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+\.\w{2,}$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: halfWidth,
                  child: AppTextFormField(
                    controller: widget.phoneController,
                    label: 'Phone Number',
                    required: false,
                    hintText: 'Enter phone number',
                    keyboardType: TextInputType.phone,
                  ),
                ),

                // Password field — only shown in Create mode
                if (widget.passwordController != null)
                  SizedBox(
                    width: halfWidth,
                    child: AppTextFormField(
                      controller: widget.passwordController,
                      label: 'Password',
                      required: true,
                      hintText: 'Enter password',
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      suffix: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: const Color(0xFF94A3B8),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
