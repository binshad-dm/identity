class CreateUserRequest {
  final String userName;
  final String email;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String password;
  final String referenceSystem;
  final String referenceValue;

  CreateUserRequest({
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.password,
    this.referenceSystem = '',
    this.referenceValue = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'referenceSystem': referenceSystem,
      'referenceValue': referenceValue,
    };
  }
}
