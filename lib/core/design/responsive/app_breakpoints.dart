import 'package:flutter/material.dart';

class AppBreakpoints {
  /// Breakpoint for mobile devices (phones)
  static const double mobile = 600.0;

  /// Breakpoint for tablet devices
  static const double tablet = 1000.0;

  /// Breakpoint for desktop/web browsers
  static const double desktop = 1200.0;

  /// Helpers for checking the current layout based on width
  static bool isMobile(double width) => width < mobile;
  static bool isTablet(double width) => width >= mobile && width < tablet;
  static bool isDesktop(double width) => width >= tablet;

  /// Helpers for checking the current layout based on BuildContext (MediaQuery)
  static bool isMobileContext(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobile;

  static bool isTabletContext(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= mobile &&
      MediaQuery.sizeOf(context).width < tablet;

  static bool isDesktopContext(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;
}
