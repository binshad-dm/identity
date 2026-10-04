import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:identity/core/design/theme/colors.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    this.label,
    this.controller,
    this.initialValue,
    this.hintText,
    this.required = false,
    this.focusNode,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onChanged,
    this.style,
    this.decoration,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.prefix,
    this.suffix,
    this.validator,
    this.autovalidateMode,
    this.maxLength,
    this.onTapOutside,
    this.textAlign = TextAlign.start,
  });

  final String? label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final bool required;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final TextStyle? style;
  final InputDecoration? decoration;
  final bool obscureText;
  final bool readOnly;
  final int? maxLines;
  final Widget? prefix;
  final Widget? suffix;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final int? maxLength;
  final TapRegionCallback? onTapOutside;
  final TextAlign textAlign;

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
                    fontSize: 13,
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
        TextFormField(
          textAlign: textAlign,
          controller: controller,
          initialValue: initialValue,
          focusNode: focusNode,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          onTapOutside: onTapOutside,
          obscureText: obscureText,
          readOnly: readOnly,
          maxLength: maxLength,
          maxLines: maxLines,
          validator: validator,
          autovalidateMode: autovalidateMode,
          style: style ?? const TextStyle(fontSize: 13),
          decoration: decoration ??
              _defaultDecoration(hintText, prefix, suffix, readOnly),
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
          borderSide: BorderSide(color: _primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        errorStyle: const TextStyle(fontSize: 11, color: Colors.redAccent),
      );
}
