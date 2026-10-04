class DiagnosisEndpoints {
  static const String _base = "clinical";

  static const String treatmentPlans = "$_base/treatment-plans";
  static String treatmentPlanDetails(String id) => "$_base/treatment-plans/$id";
  static String treatmentPlansByPatientAndSpecialization(
    String patientId,
    int specializationId,
  ) =>
      "$_base/treatment-plans/patient/$patientId/specialization/$specializationId";
  static String treatmentPlansByPatientAndEncounter(
    String patientId,
    String encounterId,
  ) =>
      "$_base/treatment-plans/patient/$patientId/encounter/$encounterId";
  static const String diagnosisMaster = "$_base/diagnosis-master";
}
