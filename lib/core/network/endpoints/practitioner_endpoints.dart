class PractitionerEndpoints {
  static const String _base = "clinical";

  static const String search = "$_base/practitioners/search";

  static String details(String id) => "$_base/practitioners/$id";

  static String updateSpecialities(String id) =>
      "$_base/practitioners/$id/specializations";

  static const String userInfo = "$_base/practitioners/user-information";
}
