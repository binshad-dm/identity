import 'package:equatable/equatable.dart';

class PaginatedResponse<T> extends Equatable {
  final List<T> content;
  final int totalPages;
  final int totalElements;
  final int numberOfElements;
  final int size;
  final int number;
  final bool first;
  final bool last;
  final bool empty;

  const PaginatedResponse({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.numberOfElements,
    required this.size,
    required this.number,
    required this.first,
    required this.last,
    required this.empty,
  });

  @override
  List<Object?> get props => [
        content,
        totalPages,
        totalElements,
        numberOfElements,
        size,
        number,
        first,
        last,
        empty,
      ];
}
