import 'package:equatable/equatable.dart';

/// Pure domain entity for a User — no data-layer dependencies.
class UserEntity extends Equatable {
  final String id;
  final String userName;
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String status; // 'ACTIVE' | 'INACTIVE'
  final List<String> roles;

  const UserEntity({
    required this.id,
    required this.userName,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber = '',
    required this.status,
    required this.roles,
  });

  /// Convenience getter: full display name.
  String get fullName => '$firstName $lastName'.trim();

  /// Convenience getter: initials for avatar.
  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();
  }

  bool get isActive => status == 'ACTIVE';

  @override
  List<Object?> get props => [id, userName, email, firstName, lastName, phoneNumber, status, roles];
}
