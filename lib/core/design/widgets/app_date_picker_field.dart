import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AppDatePickerField extends StatelessWidget {
  const AppDatePickerField({
    super.key,
    this.label,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.hintText,
    this.required = false,
    this.onDateSelected,
    this.readOnly = false,
    this.prefix,
    this.suffix,
    this.validator,
  });

  final String? label;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? hintText;
  final bool required;
  final ValueChanged<DateTime>? onDateSelected;
  final bool readOnly;
  final Widget? prefix;
  final Widget? suffix;
  final FormFieldValidator<String>? validator;

  static const _primary = Color(0xFF0F4C81);

  @override
  Widget build(BuildContext context) {
    final displayText = initialDate != null
        ? '${initialDate!.day.toString().padLeft(2, '0')}-${initialDate!.month.toString().padLeft(2, '0')}-${initialDate!.year}'
        : '';

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
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151))),
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
        InkWell(
          onTap: readOnly
              ? null
              : () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: initialDate ?? DateTime.now(),
                    firstDate: firstDate ?? DateTime(1900),
                    lastDate: lastDate ?? DateTime(2100),
                  );
                  if (picked != null && onDateSelected != null) {
                    onDateSelected!(picked);
                  }
                },
          child: IgnorePointer(
            child: TextFormField(
              key: ValueKey(initialDate),
              initialValue: displayText,
              readOnly: true,
              validator: validator,
              style: const TextStyle(fontSize: 13),
              decoration: _defaultDecoration(
                hintText ?? 'Select Date',
                prefix,
                suffix ??
                    const Icon(Icons.calendar_today,
                        size: 16, color: Color(0xFF94A3B8)),
                readOnly,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static InputDecoration _defaultDecoration(
          String? hint, Widget? prefix, Widget? suffix,
          [bool readOnly = false]) =>
      InputDecoration(
        hintText: hint,
        prefixIcon: prefix,
        suffixIcon: suffix,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
        filled: true,
        fillColor: readOnly ? const Color(0xFFF1F5F9) : const Color(0xFFF8FAFC),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          borderSide: const BorderSide(color: _primary, width: 2),
        ),
        hoverColor: Colors.transparent,
      );
}
