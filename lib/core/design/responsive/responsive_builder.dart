import 'package:flutter/material.dart';
import 'app_breakpoints.dart';
import '../../platform/platform_config.dart';

enum ScreenSize {
  small, // < 600px
  medium, // 600px - 1000px
  large, // > 1000px
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenSize screenSize) builder;
  final Widget? child;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = _getScreenSize(constraints.maxWidth);
        return builder(context, screenSize);
      },
    );
  }

  ScreenSize _getScreenSize(double width) {
    if (width < AppBreakpoints.mobile) return ScreenSize.small;
    if (width < AppBreakpoints.tablet) return ScreenSize.medium;
    return ScreenSize.large;
  }
}

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? web;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.web,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (PlatformConfig.isWeb) {
          if (width >= 1200) {
            return web ?? desktop ?? tablet ?? mobile;
          } else if (width >= 600) {
            return tablet ?? mobile;
          } else {
            return mobile;
          }
        } else if (PlatformConfig.isDesktop) {
          if (width >= 1200) {
            return desktop ?? tablet ?? mobile;
          } else {
            return tablet ?? mobile;
          }
        } else {
          return mobile;
        }
      },
    );
  }
}

class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobile;
  final EdgeInsets? tablet;
  final EdgeInsets? desktop;
  final EdgeInsets? web;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobile,
    this.tablet,
    this.desktop,
    this.web,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        EdgeInsets padding;

        if (PlatformConfig.isWeb) {
          if (width >= 1200) {
            padding = web ??
                desktop ??
                tablet ??
                mobile ??
                EdgeInsets.all(PlatformConfig.defaultPadding);
          } else if (width >= 600) {
            padding = tablet ??
                mobile ??
                EdgeInsets.all(PlatformConfig.defaultPadding);
          } else {
            padding = mobile ?? EdgeInsets.all(PlatformConfig.defaultPadding);
          }
        } else if (PlatformConfig.isDesktop) {
          if (width >= 1200) {
            padding = desktop ??
                tablet ??
                mobile ??
                EdgeInsets.all(PlatformConfig.defaultPadding);
          } else {
            padding = tablet ??
                mobile ??
                EdgeInsets.all(PlatformConfig.defaultPadding);
          }
        } else {
          padding = mobile ?? EdgeInsets.all(PlatformConfig.defaultPadding);
        }

        return Padding(padding: padding, child: child);
      },
    );
  }
}
