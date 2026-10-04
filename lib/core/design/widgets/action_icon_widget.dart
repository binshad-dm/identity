import 'package:flutter/material.dart';

class ActionIcon extends StatelessWidget {
  const ActionIcon({
    required this.icon,
    required this.onTap,
    required this.semanticsId,
    required this.label,
    this.color,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final String semanticsId;
  final String label;

  @override
  Widget build(BuildContext context) {
    final Color _primary = Theme.of(context).colorScheme.primary;

    return Semantics(
      identifier: semanticsId,
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (color ?? _primary).withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color ?? _primary,
          ),
        ),
      ),
    );
  }
}
