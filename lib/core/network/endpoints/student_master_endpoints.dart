class StudentMasterEndpoints {
  static const String _base = "academics";

  static String get students => "$_base/students";

  static String get searchStudents => students;

  static String updateStudent(String id) => "$students/$id";

  static String deleteStudent(String id) => "$students/$id";

  static String studentDetails(String id) => "$students/$id";

  static String get coursesSelect => "$_base/courses/select";

  static String courseDetails(int id) => "$_base/courses/$id";

  static String get academicBatchesSelect => "$_base/batches/select";

  static String get batchesSelect => "$_base/batches/select";
  // "${courseId != null ? '?academicCourseId.equals=$courseId' : ''}";

  static String batchDetails(int id) => "$_base/batches/$id";
  static String get studentGroupsSelect => "$_base/student-groups/select";

  static String studentGroupsSelectById(int? batchId) =>
      "$_base/student-groups/select"
      "${batchId != null ? '?academicBatchId.equals=$batchId' : ''}";

  static String studentGroupDetails(int id) => "$_base/student-groups/$id";

  static String studentEnrollments(String studentId) =>
      "$students/$studentId/enrollments";

  static String transferEnrollment(String studentId) =>
      "$students/$studentId/enrollment/transfer";

  static String repeatEnrollment(String studentId) =>
      "$students/$studentId/enrollment/repeat";

  static String completeEnrollment(String studentId) =>
      "$students/$studentId/enrollment/complete";

  static String updateEnrollment(String studentId) =>
      "$students/$studentId/enrollment/update";

  static String get bulkEnroll => "$students/bulk/enroll";
  static String get bulkTransfer => "$students/bulk/transfer";
  static String get bulkRepeat => "$students/bulk/repeat";
  static String get bulkComplete => "$students/bulk/complete";
  static String get bulkUpdateEnrollment => "$students/bulk/enrollment/update";
  static String get bulkUpdateStatus => "$students/bulk/status";
  static String get bulkDelete => "$students/bulk/delete";

  static String registrationStatus(String studentId) =>
      "$students/$studentId/registration-status";
}
