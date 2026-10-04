class PatientEndpoints {
  static const String patients = "patients";
  static const String search = "patients/search";
  static String patientDetails(String id) => "patients/$id";
}
