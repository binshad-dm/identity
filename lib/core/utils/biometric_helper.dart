import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class BiometricHelper {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      debugPrint("Biometric check failed: $e");
      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      debugPrint("Error getting biometrics: $e");
      return <BiometricType>[];
    }
  }

  static Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } on PlatformException catch (e) {
      debugPrint("Device support check failed: $e");
      return false;
    }
  }

  static Future<bool> authenticate({
    String reason = 'Please authenticate to continue',
    bool biometricOnly = true,
    bool stickyAuth = true,
    bool useErrorDialogs = true,
  }) async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) {
      debugPrint("Biometric not available.");
      return false;
    }

    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          biometricOnly: biometricOnly,
          stickyAuth: stickyAuth,
          useErrorDialogs: useErrorDialogs,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint("Authentication failed: $e");
      return false;
    }
  }
}
