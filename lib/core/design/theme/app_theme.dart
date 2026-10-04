import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:identity/core/design/theme/colors.dart';

class AppTheme extends GetxController {
  static const Color memoColorLight = Color(0xFF1976D2); // Blue for light theme
  static const Color memoColorDark = Color(
    0xFF64B5F6,
  ); // Lighter blue for dark theme
  static ThemeData _baseTheme(ColorScheme colorScheme, Color scaffoldBg) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      textTheme: TextTheme(
        displayLarge: _textStyle(24, FontWeight.bold, colorScheme.onSurface),
        displayMedium: _textStyle(20, FontWeight.w600, colorScheme.onSurface),
        displaySmall: _textStyle(16, FontWeight.normal, colorScheme.onSurface),
        bodyLarge: _textStyle(
          15,
          FontWeight.normal,
          colorScheme.onSurface,
          1.5,
        ),
        bodyMedium: _textStyle(13, FontWeight.normal, colorScheme.onSurface),
        bodySmall: _textStyle(12, FontWeight.normal, colorScheme.onSurface),
        labelLarge: _textStyle(14, FontWeight.w600, colorScheme.onSurface),
        labelMedium: _textStyle(10, FontWeight.w500, colorScheme.onSurface),
        labelSmall: _textStyle(8, FontWeight.w500, colorScheme.onSurface),
      ),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme.primary),
      // cardTheme: _cardTheme(colorScheme.surface),
      dividerTheme: _dividerTheme(colorScheme.onSurface),
      appBarTheme: _appBarTheme(colorScheme),
    );
  }

  static TextStyle _textStyle(
    double size,
    FontWeight weight,
    Color color, [
    double? height,
  ]) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      fontFamily: GoogleFonts.poppins().fontFamily,
      wordSpacing: 1,
    );
  }

  static InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      border: _outlineInputBorder(Colors.grey.shade300),
      enabledBorder: _outlineInputBorder(Colors.grey.shade300),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  static OutlineInputBorder _outlineInputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(Color primaryColor) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: _textStyle(14, FontWeight.w600, Colors.white),
      ),
    );
  }

  static CardTheme _cardTheme(Color color) {
    return CardTheme(
      color: color,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
    );
  }

  static DividerThemeData _dividerTheme(Color color) {
    return DividerThemeData(
      color: color.withValues(alpha: 0.5),
      thickness: 1,
      space: 1,
    );
  }

  static AppBarTheme _appBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      color: colorScheme.surface,
      elevation: 1,
      titleTextStyle: _textStyle(20, FontWeight.w600, colorScheme.onSurface),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
    );
  }

  static final ThemeData appTheme = _baseTheme(
    const ColorScheme.light(
      primary: AppColors.appThemeColorLight,
      secondary: Color(0xFF4A6572),
      surface: Color(0xFFF5F7FA),
      background: Color(0xFFFFFFFF),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      error: Color(0xFFB00020),
    ),
    Colors.white,
  );

  static final ThemeData bottomSheetTheme = _baseTheme(
    const ColorScheme.light(
      primary: AppColors.appThemeColorLight,
      secondary: Color(0xFF4A6572),
      surface: Color(0xFFF5F7FA),
      background: Color(0xFFFFFFFF),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      error: Color(0xFFB00020),
    ),
    Colors.white,
  );

  static final ThemeData appThemeDarkTheme = _baseTheme(
    const ColorScheme.dark(
      primary: AppColors.appThemeColorLight,
      secondary: Color(0xFF4A6572),
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFFE0E0E0),
      error: Color(0xFFCF6679),
      brightness: Brightness.dark,
    ),
    const Color(0xFF161618),
  );

  // Helper method to get memo color based on theme brightness
  static Color getMemoColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? memoColorDark
        : memoColorLight;
  }
}
