class PatientCaseSheetEndpoints {
  PatientCaseSheetEndpoints._();

  static const String patientCaseSheetsSearch =
      'clinical/patient-case-sheets/search';
  static const String patientCaseSheetsBase = 'clinical/patient-case-sheets';
  static const String pendingApprovalDashboard =
      'clinical/patient-case-sheets/pending-approval/dashboard';
  static String patientCaseSheetsById(String id) =>
      'clinical/patient-case-sheets/$id';
  static String approve(String id) => 'clinical/patient-case-sheets/$id/approve';

  static String patientCaseSheetsByEncounterAndTemplate(
          String encounterId, String templateId) =>
      'clinical/patient-case-sheets/encounter/$encounterId/template/$templateId';

  static String patientCaseSheetClose(String id) =>
      'clinical/patient-case-sheets/$id/close';
  
  static String patientCaseSheetsByEncounterAndTemplateCode(
          String encounterId, String templateCode) =>
      'clinical/patient-case-sheets/encounter/$encounterId/template-code/$templateCode';
}
