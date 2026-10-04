class StudentGroupEndpoints {
  static const String _base = "academics";

  static const String studentGroups = "$_base/student-groups";
  static String studentGroupDetails(String id) => "$_base/student-groups/$id";
}
