import 'package:flutter/material.dart';
import 'package:identity/core/design/widgets/app_confirm_dialog.dart';

void showConfirmCloseDialogue(
  BuildContext context,
  VoidCallback onActionPressed,
) {
  showDialog(
    context: context,
    builder: (context) => AppConfirmDialog(
      title: "Confirm Close",
      subtitle:
          "Are you sure you want to close this page?, Unsaved changes will be lost.",
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.orange,
      actionButtonText: 'Yes, Close',
      onActionPressed: onActionPressed,
      cancelButtonText: 'Cancel',
    ),
  );
}
