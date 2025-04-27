import 'car.dart';

class PaginatedCarList {
  final List<Car> items;
  final Pagination pagination;

  PaginatedCarList({
    required this.items,
    required this.pagination,
  });

  factory PaginatedCarList.fromJson(Map<String, dynamic> json) {
    return PaginatedCarList(
      items: (json['items'] as List<dynamic>)
          .map((item) => Car.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }
}

class Pagination {
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  Pagination({
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] as int,
      pageSize: json['page_size'] as int,
      totalItems: json['total_items'] as int,
      totalPages: json['total_pages'] as int,
      hasNext: json['has_next'] as bool,
      hasPrev: json['has_prev'] as bool,
    );
  }
}
