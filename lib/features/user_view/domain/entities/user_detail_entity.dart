import 'package:equatable/equatable.dart';

/// Full profile entity returned by `GET /api/v1/users/{id}`.
/// Kept separate from [UserEntity] (list item) so the list payload
/// is not over-fetched.
class UserDetailEntity extends Equatable {
  final String id;
  final String userName;
  final String email;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String referenceSystem;
  final String referenceValue;
  final String createdBy;
  final String createdDate;
  final String status; // 'ACTIVE' | 'INACTIVE'
  final List<String> roles;
  final bool passwordTemporary;

  const UserDetailEntity({
    required this.id,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.referenceSystem,
    required this.referenceValue,
    required this.createdBy,
    required this.createdDate,
    required this.status,
    required this.roles,
    required this.passwordTemporary,
  });

  String get fullName => '$firstName $lastName'.trim();

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
  List<Object?> get props => [
        id,
        userName,
        email,
        phoneNumber,
        firstName,
        lastName,
        referenceSystem,
        referenceValue,
        createdBy,
        createdDate,
        status,
        roles,
        passwordTemporary,
      ];
}
