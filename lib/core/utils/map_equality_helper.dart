/// Utility class to perform deep equality checks on Maps and Lists.
class MapEqualityHelper {
  MapEqualityHelper._();

  /// Checks if two maps are deeply equal.
  static bool isMapEqual(Map? map1, Map? map2) {
    if (identical(map1, map2)) return true;
    if (map1 == null && map2 == null) return true;
    if (map1 == null || map2 == null) return false;
    if (map1.length != map2.length) return false;

    for (final key in map1.keys) {
      if (!map2.containsKey(key)) return false;
      final val1 = map1[key];
      final val2 = map2[key];
      if (val1 is Map && val2 is Map) {
        if (!isMapEqual(val1, val2)) return false;
      } else if (val1 is List && val2 is List) {
        if (!isListEqual(val1, val2)) return false;
      } else if (val1 != val2) {
        return false;
      }
    }
    return true;
  }

  /// Checks if two lists are deeply equal.
  static bool isListEqual(List? list1, List? list2) {
    if (identical(list1, list2)) return true;
    if (list1 == null && list2 == null) return true;
    if (list1 == null || list2 == null) return false;
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      final val1 = list1[i];
      final val2 = list2[i];
      if (val1 is Map && val2 is Map) {
        if (!isMapEqual(val1, val2)) return false;
      } else if (val1 is List && val2 is List) {
        if (!isListEqual(val1, val2)) return false;
      } else if (val1 != val2) {
        return false;
      }
    }
    return true;
  }
}
