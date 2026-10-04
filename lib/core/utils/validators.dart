class Validators {
  static String? notEmpty(String? v, {String field = 'Field'}) =>
      (v == null || v.trim().isEmpty) ? '$field is required' : null;
  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
    return ok ? null : 'Enter a valid email';
  }
}
