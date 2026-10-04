class CaseSheetTemplateEndpoints {
  CaseSheetTemplateEndpoints._();

  static String templatesBySpecialization(int departmentId) =>
      'clinical/case-sheet-templates/specialization/$departmentId';

  static const String specializations =
      'clinical/case-sheet-templates/specialty';
}
