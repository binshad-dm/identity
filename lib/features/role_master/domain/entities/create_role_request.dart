class CreateRoleRequest {
  final String name;
  final String description;

  CreateRoleRequest({
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
    };
    return data;
  }
}
