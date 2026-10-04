import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropdownAction {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final Color? color;

  const DropdownAction({
    required this.label,
    required this.onTap,
    this.icon,
    this.color,
  });
}

class AppMoreActionsDropdown extends StatelessWidget {
  final List<DropdownAction> actions;
  final Widget? icon;
  final Color? iconColor;

  const AppMoreActionsDropdown({
    super.key,
    required this.actions,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();

    return PopupMenuButton<DropdownAction>(
      icon: icon ?? Icon(
        Icons.more_vert_rounded,
        color: iconColor ?? const Color(0xFF64748B),
        size: 20,
      ),
      tooltip: 'More actions',
      onSelected: (action) => action.onTap(),
      offset: const Offset(0, 40),
      color: Colors.white,
      constraints: const BoxConstraints(
        minWidth: 0,
        maxWidth: 200,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.08),
      itemBuilder: (BuildContext context) {
        return actions.map((action) {
          return PopupMenuItem<DropdownAction>(
            value: action,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (action.icon != null) ...[
                  Icon(
                    action.icon,
                    size: 18,
                    color: action.color ?? const Color(0xFF1E293B),
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  action.label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: action.color ?? const Color(0xFF1E293B),
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
