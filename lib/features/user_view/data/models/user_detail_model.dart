import '../../domain/entities/user_detail_entity.dart';

/// Data-layer model — extends [UserDetailEntity] for JSON mapping
/// from `GET /api/v1/users/{id}`.
class UserDetailModel extends UserDetailEntity {
  const UserDetailModel({
    required super.id,
    required super.userName,
    required super.email,
    required super.phoneNumber,
    required super.firstName,
    required super.lastName,
    required super.referenceSystem,
    required super.referenceValue,
    required super.createdBy,
    required super.createdDate,
    required super.status,
    required super.roles,
    required super.passwordTemporary,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      id: json['id']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      referenceSystem: json['referenceSystem']?.toString() ?? '',
      referenceValue: json['referenceValue']?.toString() ?? '',
      createdBy: json['createdBy']?.toString() ?? '',
      createdDate: json['createdDate']?.toString() ?? '',
      status: json['status']?.toString() ?? 'ACTIVE',
      roles: (json['roles'] as List<dynamic>?)
              ?.map((r) => r.toString())
              .toList() ??
          [],
      passwordTemporary: json['passwordTemporary'] as bool? ?? false,
    );
  }
}
