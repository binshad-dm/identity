class EditableDurationHelper {
  /// Determines if a case sheet is locked based on its creation time and the practitioner's configured editable duration.
  static bool isLocked({
    required DateTime? createdAt,
    required int editableMinutes,
  }) {
    if (createdAt == null) return false;
    if (editableMinutes <= 0) return false;

    final expiryTime = createdAt.add(Duration(minutes: editableMinutes));
    return DateTime.now().isAfter(expiryTime);
  }
}
