class DentalLabMasterEndpoints {
  static const String dentalLabs = 'clinical/dental-labs';
  static const String dentalLabsSelect = 'clinical/dental-labs/select';
  static String updateDentalLab(String id) => 'clinical/dental-labs/$id';
  static String deactivateDentalLab(String id) => 'clinical/dental-labs/$id/deactivate';
  static const String countriesSelect = 'clinical/countries/select';
}
