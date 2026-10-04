class PrescriptionEndpoints {
  static const String pending = 'prescriptions/pending';
  static String approve(String id) => 'prescriptions/$id/approve';
  static const String uoms = '/prescriptions/catalog/uoms';
  static const String routes = '/prescriptions/catalog/routes';
  static const String generics = '/prescriptions/catalog/generics';
  static const String dosages = '/prescriptions/catalog/dosages';
  static const String brands = '/prescriptions/catalog/brands';
  static const String remarks = '/prescriptions/catalog/remarks';

  static const String base = '/prescriptions';
  static String encounter(String id) => '/prescriptions/encounter/$id';
  static String update(String prescriptionId) => '$base/$prescriptionId';
  static const String byEncounters = '/prescriptions/by-encounters';
}
