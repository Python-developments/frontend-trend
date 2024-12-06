class PagedList<JsonSerializable> {
  final int? nextPageNumber;
  final List<JsonSerializable> items;

  PagedList({
    required this.nextPageNumber,
    required this.items,
  });
}
