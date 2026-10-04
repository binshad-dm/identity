class CourseMasterEndpoints {
  static const String courses = "academics/courses";
  static const String coursesSelect = "academics/courses/select";
  static String courseDetails(String id) => "academics/courses/$id";
  static String courseDeactivate(String id) =>
      "academics/courses/$id/deactivate";
}
