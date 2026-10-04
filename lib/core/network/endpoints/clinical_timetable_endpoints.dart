class ClinicalTimetableEndpoints {
  static const String _base = "academics";

  static String get clinicalTimetables => "$_base/clinical-timetable";

  static String get academicYears => "$_base/academic-course-years";

  static String get clinicalDepartments => "$_base/clinical-departments";

  static String get studentGroupsSelectAll => "$_base/student-groups/select";

  static String studentGroupsSelect(int batchId) =>
      "$_base/student-groups/select?academicBatchId.equals=$batchId";
}
