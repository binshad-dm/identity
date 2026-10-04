class CaseSheetTemplateSectionEndpoints {
  CaseSheetTemplateSectionEndpoints._();

  static const String basePath = 'clinical/case-sheet-templates';

  static const String getDepartments = 'clinical/specializations/select';

  static const String getTemplatesList = '$basePath?includeInactive=false';

  static String getTemplateById(String id) => '$basePath/$id';

  static String updateTemplateResources(String id) =>
      '$basePath/$id/resources';

  static const String getTemplatesBySpecialty =
      '$basePath/specialty?includeInactive=false';

  static String getTemplatesBySpecialization(String specializationId) =>
      '$basePath/specialization/$specializationId?includeInactive=false';
}
