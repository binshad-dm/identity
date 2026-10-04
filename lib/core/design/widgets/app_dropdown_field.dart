import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:identity/core/design/theme/colors.dart';

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.required = false,
    this.focusNode,
    this.isExpanded = true,
    this.validator,
    this.hintText,
    this.readOnly = false,
  });

  final String? label;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool required;
  final FocusNode? focusNode;
  final bool isExpanded;
  final String? Function(T?)? validator;
  final String? hintText;
  final bool readOnly;

  static const _primary = AppColors.appThemeColorLight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Row(
            children: [
              Text(label!,
                  style: const TextStyle(
                    fontSize: 12,
                  )),
              if (required)
                const Text(' *',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
            ],
          ),
          const Gap(4),
        ],
        DropdownButtonFormField<T>(
          key: ValueKey(value),
          value: value,
          items: items,
          onChanged: readOnly ? null : onChanged,
          focusNode: focusNode,
          isExpanded: isExpanded,
          validator: validator,
          hint: hintText != null
              ? Text(
                  hintText!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.normal,
                  ),
                )
              : null,
          style: const TextStyle(fontSize: 13, color: Colors.black),
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              size: 18, color: readOnly ? Colors.grey : null),
          decoration: _defaultDecoration(hintText, readOnly),
        ),
      ],
    );
  }

  static InputDecoration _defaultDecoration(
          [String? hint, bool readOnly = false]) =>
      InputDecoration(
        filled: true,
        hintText: hint,
        hintStyle: const TextStyle(
            fontSize: 13,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.normal),
        fillColor: readOnly ? const Color(0xFFF1F5F9) : const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primary, width: 2),
        ),
      );
}
