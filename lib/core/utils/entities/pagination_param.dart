class PaginationParam {
  int page;
  String? name;
  int pageSize;

  PaginationParam({
    required this.page,
    this.name,
    this.pageSize = 10,
  });
}

int? getPageNumberFromUrl(String? url) {
  if (url == null || url.isEmpty) {
    return null;
  }

  Uri uri = Uri.parse(url);

  Map<String, String> queryParams = uri.queryParameters;

  String? pageValue = queryParams['page'];

  int pageNumber = int.tryParse(pageValue ?? '') ?? 1;

  return pageNumber;
}
