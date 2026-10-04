import '../../domain/entities/user_entity.dart';

/// Data-layer model — extends [UserEntity] for JSON mapping.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.userName,
    required super.email,
    required super.firstName,
    required super.lastName,
    super.phoneNumber = '',
    required super.status,
    required super.roles,
  });

  /// Maps from the API's `UserResponseDto` JSON structure.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      status: json['status']?.toString() ?? 'ACTIVE',
      roles: (json['roles'] as List<dynamic>?)
              ?.map((r) => r.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'status': status,
      'roles': roles,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      userName: entity.userName,
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      phoneNumber: entity.phoneNumber,
      status: entity.status,
      roles: entity.roles,
    );
  }
}
