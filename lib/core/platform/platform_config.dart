import 'package:flutter/foundation.dart';

enum PlatformType {
  ios,
  android,
  web,
  desktop,
  unknown,
}

class PlatformConfig {
  static PlatformType get currentPlatform {
    if (kIsWeb) return PlatformType.web;
    if (defaultTargetPlatform == TargetPlatform.iOS) return PlatformType.ios;
    if (defaultTargetPlatform == TargetPlatform.android)
      return PlatformType.android;
    if (defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux)
      return PlatformType.desktop;
    return PlatformType.unknown;
  }

  static bool get isMobile =>
      currentPlatform == PlatformType.ios ||
      currentPlatform == PlatformType.android;
  static bool get isWeb => currentPlatform == PlatformType.web;
  static bool get isDesktop => currentPlatform == PlatformType.desktop;
  static bool get isIOS => currentPlatform == PlatformType.ios;
  static bool get isAndroid => currentPlatform == PlatformType.android;

  static double get defaultPadding {
    switch (currentPlatform) {
      case PlatformType.ios:
        return 16.0;
      case PlatformType.android:
        return 16.0;
      case PlatformType.web:
        return 24.0;
      case PlatformType.desktop:
        return 32.0;
      default:
        return 16.0;
    }
  }

  static double get defaultRadius {
    switch (currentPlatform) {
      case PlatformType.ios:
        return 8.0;
      case PlatformType.android:
        return 4.0;
      case PlatformType.web:
        return 12.0;
      case PlatformType.desktop:
        return 16.0;
      default:
        return 8.0;
    }
  }

  static Duration get animationDuration {
    switch (currentPlatform) {
      case PlatformType.ios:
        return const Duration(milliseconds: 300);
      case PlatformType.android:
        return const Duration(milliseconds: 250);
      case PlatformType.web:
        return const Duration(milliseconds: 200);
      case PlatformType.desktop:
        return const Duration(milliseconds: 150);
      default:
        return const Duration(milliseconds: 300);
    }
  }

  static String get platformName {
    switch (currentPlatform) {
      case PlatformType.ios:
        return 'iOS';
      case PlatformType.android:
        return 'Android';
      case PlatformType.web:
        return 'Web';
      case PlatformType.desktop:
        return 'Desktop';
      default:
        return 'Unknown';
    }
  }
}
