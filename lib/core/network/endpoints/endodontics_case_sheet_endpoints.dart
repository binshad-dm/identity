class EndodonticsCaseSheetEndpoints {
  EndodonticsCaseSheetEndpoints._();

  static const String endodonticsCaseSheetsSearch =
      'clinical/patient-case-sheets/search';
  static const String endodonticsCaseSheetsBase = 'clinical/patient-case-sheets';
  static const String pendingApprovalDashboard =
      'clinical/patient-case-sheets/pending-approval/dashboard';
  static String endodonticsCaseSheetsById(String id) =>
      'clinical/patient-case-sheets/$id';
  static String approve(String id) => 'clinical/patient-case-sheets/$id/approve';

  static String endodonticsCaseSheetsByEncounterAndTemplate(
          String encounterId, String templateId) =>
      'clinical/patient-case-sheets/encounter/$encounterId/template/$templateId';
}
