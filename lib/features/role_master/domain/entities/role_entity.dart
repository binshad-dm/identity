import 'package:equatable/equatable.dart';

class RoleEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String status;

  const RoleEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
  });

  @override
  List<Object?> get props => [id, name, description, status];
}
