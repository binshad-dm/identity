class AppointmentEndpoints {
  static const String schedules = "clinical/treatment-schedules";
  static const String schedulesSelect = "clinical/treatment-schedules/select";
  static String scheduleDetails(String id) => "clinical/treatment-schedules/$id";
  static String scheduleDeactivate(String id) =>
      "clinical/treatment-schedules/$id/deactivate";
}
