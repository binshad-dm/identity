class InvestigationEndpoints {
  static const String _base = "clinical";

  static const String investigations = "$_base/investigations";
  static const String investigationRequests = "$_base/investigation-requests";
  static const String investigationRequestsByEncounters =
      "$_base/investigation-requests/by-encounters";
  static String investigationRequestDetails(String id) =>
      "$_base/investigation-requests/$id";
  static String investigationRequestsByEncounter(String encounterId) =>
      "$_base/investigation-requests/encounter/$encounterId";
  static String investigationDetails(int id) => "$_base/investigations/$id";
  static const String treatmentMaster = "$_base/treatment-master";
  InvestigationEndpoints._();

  static const String pendingApproval =
      'clinical/investigation-requests/pending-approval';

  static String approve(String id) =>
      'clinical/investigation-requests/$id/approve';
}
