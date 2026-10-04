class EditableDurationLockUtil {
  /// Generic lock check — usable for any module (prescriptions, case sheets, etc.)
  static bool isLocked({
    required DateTime? createdAt,
    required int editableMinutes,
  }) {
    if (createdAt == null) return false;
    if (editableMinutes <= 0) return false;
    final expiryTime = createdAt.add(Duration(minutes: editableMinutes));
    return DateTime.now().isAfter(expiryTime);
  }

  static bool isCaseSheetLocked({
    required DateTime? createdAt,
    required int durationMinutes,
  }) {
    if (createdAt == null) return false;
    if (durationMinutes <= 0) return false;
    
    final expiryTime = createdAt.add(
      Duration(minutes: durationMinutes),
    );

    return DateTime.now().isAfter(expiryTime);
  }

  static DateTime? getExpiryTime({
    required DateTime? createdAt,
    required int durationMinutes,
  }) {
    if (createdAt == null) return null;
    return createdAt.add(
      Duration(minutes: durationMinutes),
    );
  }
}
