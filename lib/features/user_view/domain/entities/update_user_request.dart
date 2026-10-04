/// Request model for `PUT /api/v1/users/{id}`.
///
/// The [id] is used only as a path parameter — it is NOT included in the
/// serialized request body. The body contains only the editable fields
/// accepted by the backend.
class UpdateUserRequest {
  /// User ID — used as the URL path parameter only.
  final String id;

  // ── Editable fields (sent in the request body) ─────────────────────────────
  final String userName;
  final String email;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String referenceSystem;
  final String referenceValue;

  UpdateUserRequest({
    required this.id,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    this.referenceSystem = '',
    this.referenceValue = '',
  });

  /// Serializes only the fields accepted by the backend.
  /// The [id] is intentionally excluded — it goes in the URL, not the body.
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'referenceSystem': referenceSystem,
      'referenceValue': referenceValue,
    };
  }
}
