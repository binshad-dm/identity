class PaginatedResponse<T> {
  final List<T> content;
  final int totalElements;
  final int totalPages;
  final int size;
  final int number;

  PaginatedResponse({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.number,
  });

  // Mapper for the UI component
  dynamic toPaginatedData() {
    // We'll import PaginatedData here or in the caller
    // Actually, better to keep the model generic.
    // I'll use it in the Cubit.
  }

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final rawSize = json['pageSize'] ?? json['size'] ?? 10;
    int pageNum = 1;
    if (json['pageNumber'] != null) {
      pageNum = (json['pageNumber'] is int)
          ? json['pageNumber']
          : (int.tryParse(json['pageNumber'].toString()) ?? 1);
    } else if (json['number'] != null) {
      final n = (json['number'] is int)
          ? json['number']
          : (int.tryParse(json['number'].toString()) ?? 0);
      pageNum = n + 1;
    }
    return PaginatedResponse<T>(
      content: (json['content'] as List).map(fromJsonT).toList(),
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      size: rawSize is int ? rawSize : (int.tryParse(rawSize.toString()) ?? 10),
      number: pageNum,
    );
  }
}
