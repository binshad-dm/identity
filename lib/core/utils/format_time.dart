import 'package:intl/intl.dart';

String formatTimeToAmPm(String time) {
  try {
    if (time.isEmpty) return '00:00 AM';
    final parts = time.split(':');
    if (parts.length != 2) return time;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) return time;

    final dt = DateTime(2024, 1, 1, hour, minute);
    return DateFormat.jm().format(dt);
  } catch (_) {
    return time;
  }
}
