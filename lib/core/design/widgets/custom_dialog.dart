import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:identity/core/design/widgets/app_button.dart';

class CustomDialog extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final String? title;
  final String? contentText;
  final Widget? contentWidget;
  final String primaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final String secondaryButtonText;
  final VoidCallback? onSecondaryPressed;

  const CustomDialog({
    super.key,
    this.icon,
    this.iconColor,
    this.title,
    this.contentText,
    this.contentWidget,
    this.primaryButtonText = 'OK',
    this.onPrimaryPressed,
    this.secondaryButtonText = 'Cancel',
    this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    final lightBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      borderRadius: BorderRadius.circular(8),
    );

    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: lightBorder,
          focusedBorder: lightBorder.copyWith(
            borderSide: const BorderSide(color: Colors.blueAccent, width: 1.2),
          ),
        ),
      ),
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            if (icon != null) Icon(icon, color: iconColor ?? Colors.blue),
            if (icon != null) const SizedBox(width: 8),
            if (title != null)
              Text(title!, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        content:
            contentWidget ??
            (contentText != null
                ? Text(
                    contentText!,
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  )
                : null),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppOutlinedButton(
                onPressed: onSecondaryPressed ?? () => Navigator.pop(context),
                text: secondaryButtonText,
              ),
              Gap(16),
              AppButton(onPressed: onPrimaryPressed, text: primaryButtonText),
            ],
          ),
        ],
      ),
    );
  }
}
