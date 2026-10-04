import 'package:flutter/material.dart';
import 'package:identity/core/design/widgets/app_button.dart';

class CreateUserActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onCreate;
  final bool isLoading;
  final bool isUpdate;

  const CreateUserActions({
    super.key,
    required this.onCancel,
    required this.onCreate,
    required this.isLoading,
    this.isUpdate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppOutlinedButton(
          text: 'Cancel',
          icon: const Icon(Icons.close_rounded, size: 16),
          iconPosition: AppButtonIconPosition.prefix,
          onPressed: isLoading ? null : onCancel,
        ),
        const SizedBox(width: 16),
        AppButton(
          text: isLoading
              ? (isUpdate ? 'Updating...' : 'Saving...')
              : (isUpdate ? 'Update' : 'Save'),
          icon: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.save_rounded, size: 16),
          iconPosition: AppButtonIconPosition.prefix,
          onPressed: isLoading ? null : onCreate,
        ),
      ],
    );
  }
}
