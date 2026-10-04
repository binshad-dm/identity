import 'package:flutter/material.dart';
import 'package:identity/core/design/theme/colors.dart';

enum AppButtonIconPosition {
  prefix,
  suffix,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool enabled;
  final String variant;
  final AppButtonIconPosition iconPosition;
  final Color? color;
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.enabled = true,
    this.variant = 'primary',
    this.iconPosition = AppButtonIconPosition.prefix,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: appliedTheme.width,
      height: 36,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.appThemeColorLight,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: enabled ? onPressed : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null &&
                iconPosition == AppButtonIconPosition.prefix) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(text),
            if (icon != null &&
                iconPosition == AppButtonIconPosition.suffix) ...[
              const SizedBox(width: 8),
              icon!,
            ],
          ],
        ),
      ),
    );
  }
}

class AppOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool enabled;
  final String variant;
  final AppButtonIconPosition iconPosition;
  final Color? color;
  const AppOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.enabled = true,
    this.variant = 'primary',
    this.iconPosition = AppButtonIconPosition.suffix,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: color ?? AppColors.appThemeColorLight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        onPressed: enabled ? onPressed : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null &&
                iconPosition == AppButtonIconPosition.prefix) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(text),
            if (icon != null &&
                iconPosition == AppButtonIconPosition.suffix) ...[
              const SizedBox(width: 8),
              icon!,
            ],
          ],
        ),
      ),
    );
  }
}
