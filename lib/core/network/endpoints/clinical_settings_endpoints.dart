class ClinicalSettingsEndpoints {
  ClinicalSettingsEndpoints._();

  static const String clinicalSettings = 'clinical/clinical-settings';
  static String updateClinicalSettings(String id) =>
      'clinical/clinical-settings/$id';

  static const String resolvedSettings = 'configuration/settings/resolved';
  static const String settingsDefinitions = 'configuration/settings';
  static String settingOverrides(String settingKey) =>
      'configuration/settings/$settingKey/overrides';
  static String settingsOverrideGlobal(String settingsKey) =>
      'configuration/settings/$settingsKey/default';
}
