import 'package:flutter/material.dart';

/// Reusable status badge ensuring design and theme uniformity across all features
/// (User Master, Role Master, Login History, Dialogs).
class AppStatusBadge extends StatelessWidget {
  final String status;
  final bool? isActive;
  final bool showDot;
  final EdgeInsetsGeometry? padding;
  final double fontSize;

  const AppStatusBadge({
    super.key,
    required this.status,
    this.isActive,
    this.showDot = true,
    this.padding,
    this.fontSize = 11,
  });

  bool get _resolvedIsActive {
    if (isActive != null) return isActive!;
    final upper = status.trim().toUpperCase();
    return upper == 'ACTIVE' || upper == 'SUCCESS' || upper == 'ENABLED';
  }

  @override
  Widget build(BuildContext context) {
    final active = _resolvedIsActive;

    // Harmonized palette
    final bgColor = active ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2);
    final fgColor = active ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    final borderColor = active ? const Color(0xFFBBF7D0) : const Color(0xFFFECDD3);

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: fgColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            status,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: fgColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
