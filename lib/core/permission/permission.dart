class StubUserPermission {
  static const Map<String, bool> permission = {
    Permission.clinicalSettingUpdate: true,
    Permission.clinicalSettingView: true,
  };
}

class Permission {
  static const String clinicalSettingUpdate =
      "Permission.clinicalSetting.update";
  static const String clinicalSettingView = "Permission.clinicalSettings.view";
}
