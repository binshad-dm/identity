enum UserRole {
  doctor,
  student,
}

class UserContext {
  UserRole _role = UserRole.doctor;
  String? _studentId;

  UserRole get role => _role;
  bool get isStudent => _role == UserRole.student;
  String? get studentId => _studentId;

  void setDoctor() {
    _role = UserRole.doctor;
    _studentId = null;
  }

  void setStudent(String id) {
    final normalizedId = id.trim();
    _role = UserRole.student;
    _studentId = normalizedId;
  }
}
