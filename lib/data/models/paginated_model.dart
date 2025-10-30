class PaginatedModel<T> {
  final int currentPage;
  final int lastPage;
  final int total;
  final List<T> data;

  PaginatedModel({
    required this.currentPage,
    required this.data,
    required this.lastPage,
    required this.total,
  });

  factory PaginatedModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final List<T> parsedData = (json["data"]["items"] as List? ?? [])
        .map((item) => fromJson(item as Map<String, dynamic>))
        .toList();

    return PaginatedModel<T>(
      currentPage: (json["data"]["current_page"] is String)
          ? int.tryParse(json["data"]?["current_page"])
          : (json["data"]?["current_page"] is int)
          ? json["data"]["current_page"]
          : 1,
      data: parsedData,
      lastPage: json["data"]["last_page"] ?? 1,
      total: json["data"]["total"] ?? 0,
    );
  }
}
