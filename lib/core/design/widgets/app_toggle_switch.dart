import 'package:flutter/material.dart';

class AppToggleSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? inactiveTrackColor;
  final double scale;
  final AlignmentGeometry alignment;

  const AppToggleSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.inactiveTrackColor,
    this.scale = 0.85,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      alignment: alignment,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white,
        activeTrackColor: activeColor ?? Theme.of(context).primaryColor,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: inactiveTrackColor ?? const Color(0xFFCBD5E1),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
