import 'package:equatable/equatable.dart';

class RoleSelectItem extends Equatable {
  final String id;
  final String name;

  const RoleSelectItem({
    required this.id,
    required this.name,
  });

  factory RoleSelectItem.fromJson(Map<String, dynamic> json) {
    return RoleSelectItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [id, name];
}
