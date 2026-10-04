class EncounterEndpoints {
  static String patientEncounters(String patientId) =>
      '/encounters/patient/$patientId';

  static String waitingEncounters(int specializationId) =>
      '/encounters/specialization/$specializationId/waiting';

  static const String myEncounters = '/encounters/me';
  static String claimEncounter(String id) => '/encounters/$id/claim';
  static String unclaimEncounter(String id) => '/encounters/$id/unclaim';
  static String stopEncounter(String id) => '/encounters/$id/stop';
  static String cancelEncounter(String id) => '/encounters/$id/cancel';
  static String completeEncounter(String id) => '/encounters/$id/complete';
  static String enteredInErrorEncounter(String id) =>
      '/encounters/$id/entered-in-error';
  static const String mySpecializations = '/encounters/me/specializations';
  static String oversightEncounters(int specializationId) =>
      '/encounters/specialization/$specializationId/oversight';

  // --- Patient Transfer endpoints ---
  static String eligibleStudents(String encounterId) =>
      '/encounters/$encounterId/eligible-students';
  static String transferEncounter(String encounterId) =>
      '/encounters/$encounterId/transfer';
  static String transferHistory(String encounterId) =>
      '/encounters/$encounterId/transfers';

}
