// Endpoints for the new appointment booking flow.
// NOTE: paths are relative to the Dio base URL which already includes /api/v1/
class AppointmentBookingEndpoints {
  static const String practitionerSessions = 'practitioner-sessions';
  static const String availableTokens =
      'practitioner-sessions/available-tokens';
  static const String appointments = 'appointments';
  static const String treatmentPlanLink = 'treatment-plans/link';

  static String reschedule(String id) => 'appointments/$id/reschedule';
  static String noShow(String id) => 'appointments/$id/no-show';
  static String enteredInError(String id) => 'appointments/$id/entered-in-error';
  static String checkIn(String id) => 'appointments/$id/check-in';
  static String cancel(String id) => 'appointments/$id/cancel';
}
