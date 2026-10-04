class TreatmentPlanEndpoints {
  static const String _base = "clinical";

  static const String pendingApproval = "$_base/treatment-plans/pending-approval";
  static String approve(String id) => "$_base/treatment-plans/$id/approve";

  TreatmentPlanEndpoints._();
}
