class TreatmentSummaryEndpoints {
  TreatmentSummaryEndpoints._();

  static const String _base = '/clinical/treatment-summaries';

  static String fetchHistory(String patientId) => '$_base/patient/$patientId';
  static String fetchSummaryById(String id) => '$_base/$id';
  static const String generatePreview = '$_base/preview';
  static const String createSummary = _base;
}
