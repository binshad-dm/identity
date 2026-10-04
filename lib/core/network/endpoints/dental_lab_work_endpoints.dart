class DentalLabWorkEndpoints {
  static const String proximalContactsSelect =
      'clinical/proximal-contacts/select';
  static const String ponticDesignsSelect = 'clinical/pontic-designs/select';
  static const String gingivaColorsSelect = 'clinical/gingiva-colors/select';
  static const String labTrialTypesSelect = 'clinical/lab-trial-types/select';
  static const String impressionMaterialsSelect =
      'clinical/impression-materials/select';
  static const String labShadeGuidesSelect = 'clinical/lab-shade-guides/select';
  static const String cervicalShadesSelect = 'clinical/cervical-shades/select';
  static const String middleShadesSelect = 'clinical/middle-shades/select';
  static const String incisalShadesSelect = 'clinical/incisal-shades/select';
  static const String saveLabWork = 'clinical/lab-cases';
  static const String updateLabWork = 'clinical/lab-cases';
  static const String getLabWorks = 'clinical/lab-cases/patient';
  static const String dentalLabsSelect = 'clinical/dental-labs/select';
  static const String worksSelect = 'clinical/treatment-master/select/lab';
  static const String labWorkStatuses = 'clinical/lab-cases/statuses';
  static const String updateLabWorkStatus = 'clinical/lab-cases';
  static const String deleteLabWork = 'clinical/lab-cases';
  static const String pendingApproval = 'clinical/lab-cases/pending-approval';
  static String approve(String id) => 'clinical/lab-cases/$id/approve';
}
