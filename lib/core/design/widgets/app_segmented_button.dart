import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppSegmentedButton<T extends Object> extends StatelessWidget {
  const AppSegmentedButton({
    super.key,
    required this.groupValue,
    required this.children,
    required this.onValueChanged,
    this.width = 320.0,
  });

  final T groupValue;
  final Map<T, String> children;
  final ValueChanged<T> onValueChanged;
  final double width;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveColor = isDark ? Colors.white38 : Colors.black45;

    final Map<T, Widget> segmentedChildren = {};
    children.forEach((key, label) {
      segmentedChildren[key] = Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
            color: groupValue == key ? Colors.white : inactiveColor,
          ),
        ),
      );
    });

    return Center(
      child: SizedBox(
        width: width,
        child: CupertinoSlidingSegmentedControl<T>(
          groupValue: groupValue,
          thumbColor: const Color(0xFF0F4C81),
          backgroundColor: isDark
              ? Colors.white.withOpacity(0.04)
              : const Color(0xFFF1F5F9), // Subtle light slate fill
          children: segmentedChildren,
          onValueChanged: (T? value) {
            if (value != null) {
              HapticFeedback.lightImpact();
              onValueChanged(value);
            }
          },
        ),
      ),
    );
  }
}
